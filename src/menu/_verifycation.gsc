//Setup Verifycation Levels
init_verifycation_system()
{
    addVerifycationLevel(0,"UnVerified","^7");
    addVerifycationLevel(1,"Verified","^5");
    addVerifycationLevel(2,"Vip","^2");
    addVerifycationLevel(3,"Admin","^4");
    addVerifycationLevel(4,"Host","^1");
}


//Player Verifycation Monitor
player_monitor_verifycation()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("verifycation_level_changed");
        if(self getVerifycationLevel()>0)
        {
            if(!self.hasMenu)
            {
                self thread doAccessInfoMSG();
                self giveMenu();
            }
            else
            {
                if(self getMenuVar("opened"))
                {
                    self _closeMenu();
                }
            }
        }
        else
        {
            if(self.hasMenu)
            {
                self removeMenu();
                self thread doAccessInfoMSG();
            }
        }
        self iprintlnBold("Verifycation Level Changed To: " + getVerifycationLevel_Color(self getVerifycationLevel()) + getVerifycationLevel_String(self getVerifycationLevel()));
        wait 0.05;
    }
}

//First Spawn Verifycation
player_set_verifycation_on_first_spawn()
{
    if(self isHost())
    {
        setPlayerVerifycationLevel(self,4,true);
    }
    else
    {
        setPlayerVerifycationLevel(self,0);
    }
}


//Set Verifycation Level for player
setPlayerVerifycationLevel(client,vlevel,host_force = false)
{
    if(client isVerifycationLevel(vlevel) || (client isHost() && !host_force))
    {
        self iprintln("^1You can't do that with the host player!!!");
        return;
    }
    client.verifycation_level = vlevel;
    client notify("verifycation_level_changed");
    if(isDefined(self) && isPlayer(self))
    {
        self iprintln("Changed " + client.name + "'s Verifycation Level to: " + getVerifycationLevel_Color(client.verifycation_level) + getVerifycationLevel_String(client.verifycation_level));
    }
}


//Get Verifycation Level
getVerifycationLevel()
{
    if(isDefined(self.verifycation_level))
    {
        return self.verifycation_level;
    }
    return undefined;
}

//Check for Verifycation Level
isVerifycationLevel(vlevel)
{
    if((self.verifycation_level==vlevel) && isDefined(self.verifycation_level))
    {
        return true;
    }
    return false;
}


//Menu Access Message ---- i still dont like it
doAccessInfoMSG()
{
    if(self.AccessInfoMSG_isActive)
    {
        return;
    }
    self.AccessInfoMSG_isActive = true;
    self.text_vLevel            = createText("objective",1.5,"LEFT","LEFT",-700,0,(1,1,1),1,(0,0,0),0,"Verifycation Status: " + getVerifycationLevel_Color(self.verifycation_level) + getVerifycationLevel_String(self.verifycation_level));
    text                        = (self getVerifycationLevel()>0) ? "Press ^3[{+melee}]^7 + ^3[{+speed_throw}]^7 to Open Menu!" : "^1No Menu Access!";
    self.text_access            = createText("objective",1.5,"LEFT","LEFT",-700,20,(1,1,1),1,(0,0,0),0,text);
    self.text_vLevel elemMoveOverTimeX(.7,0);
    wait .3;
    self.text_access elemMoveOverTimeX(.7,0);
    wait .10;
    self thread ent_notify_after_time_period(7,"remove_access_msg","new_verifycation_info");
    self waittill("remove_access_msg");
    self.text_access elemMoveOverTimeX(.4,20);
    wait .4;
    self.text_access elemMoveOverTimeX(.7,-700);
    self.text_vLevel elemMoveOverTimeX(.4,20);
    wait .4;
    self.text_vLevel elemMoveOverTimeX(.7,-700);
    wait .8;
    self.text_vLevel destroy();
    self.text_access destroy();
    self.AccessInfoMSG_isActive = false;
}


//Get Verifycation Level String
getVerifycationLevel_String(vlevel)
{
    if(isDefined(level.VerifycationLevels[vlevel].string))
    {
        return level.VerifycationLevels[vlevel].string;
    }
    iprintln("^1UNKNOWN string for vlevel: " + vlevel);
}

//Get Verifycation Level Color
getVerifycationLevel_Color(vlevel)
{
    if(isDefined(level.VerifycationLevels[vlevel].color_string))
    {
        return level.VerifycationLevels[vlevel].color_string;
    }
    iprintln("^1UNKNOWN color_string for vlevel: " + vlevel);
}

//Add Verifycation Level ----- for verifycation setup
addVerifycationLevel(vlevel,string,color_string)
{
    if(!isDefined(level.VerifycationLevels))
    {
        level.VerifycationLevels = [];
    }
    level.VerifycationLevels[vlevel] = spawnStruct();
    level.VerifycationLevels[vlevel].string = string;
    level.VerifycationLevels[vlevel].color_string = color_string;
}


//Check if player has the min Verifycation Level
hasMinVerifycationLevel(index,error_msg = false)
{
    min_vlevel = (isDefined(self.Menu[self getCurrentMenu()].min_verifycation_level[index])) ? self.Menu[self getCurrentMenu()].min_verifycation_level[index] : 1;
    return_val = (self getVerifycationLevel()>=min_vlevel) ? true : false;
    if(!return_val && error_msg)
    {
        self iprintlnBold("Verifycation Level " + getVerifycationLevel_Color(min_vlevel) + getVerifycationLevel_String(min_vlevel) + " ^7or Higher Needed!");
    }
    return return_val;
}

//Get player list sorted by verifycation level
sortPlayerListByVerifycationLevel()
{
    list             = [];
    players_to_check = level.players.size;
    check_vlevel     = 0;
    while((players_to_check > 0) && (check_vlevel <= level.VerifycationLevels.size))
    {
        for(i=0;i<level.players.size;i++)
        {
            if(level.players[i] getVerifycationLevel() == check_vlevel)
            {
                list[list.size] = level.players[i];
                players_to_check --;
            }
        }
        check_vlevel ++;
    }
    return list;
}