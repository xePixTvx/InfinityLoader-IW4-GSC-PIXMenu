init_server_bools()
{
}


update_player_bools_after_spawn()
{
    if(self.isFirstSpawn)
    {
        self.pix_godmode     = false;
        self.pix_unlm_ammo   = false;
        self.pix_invisible   = false;
        self.Clone_Follow    = false;
        self.isGoingToSpace  = false;
        self.pix_flashy_dude = false;
        self.GunSideVal      = 1;
        self setClientDvar("cg_gun_y",0);
        self setClientDvar("cg_gun_x",0);
        self.GunSideShow     = @"Default";
        self.ViewPortVal     = 1;
        self setClientDvar("r_scaleviewport",1);
        self.ViewPortShow    = @"Default";
    }
    else
    {
        if(self.Clone_Follow)
        {
            self.Clone_Follow = false;
        }
        if(self.pix_invisible)
        {
            self hide();
        }
        self.isGoingToSpace = false;
    }
}




//Godmode
ToggleGodMode()
{
    if(self.pix_godmode)
    {
        self.pix_godmode = false;
        self iprintln("Godmode: ^1OFF");
        return;
    }
    self.pix_godmode = true;
    self iprintln("Godmode: ^2ON");
    self.maxHealth = 99999;
    self.health    = self.maxHealth;
    while(self.pix_godmode)
    {
        if(self.health<self.maxHealth)
        {
            self.health = self.maxHealth;
        }
        wait 0.01;
    }
    self.maxHealth = 100;
    self.health    = self.maxHealth;
}


//Unlimited Ammo
ToggleUnlimitedAmmo()
{
    if(self.pix_unlm_ammo)
    {
        self.pix_unlm_ammo = false;
        self iprintln("Unlimited Ammo: ^1OFF");
        return;
    }
    self.pix_unlm_ammo = true;
    self iprintln("Unlimited Ammo: ^2ON");
    while(self.pix_unlm_ammo)
    {
        currentWeapon = self getCurrentWeapon();
        if(currentWeapon!="none")
        {
            if(isSubStr(self getCurrentWeapon(),"_akimbo_"))
            {
                self setWeaponAmmoClip(currentweapon,9999,"left");
                self setWeaponAmmoClip(currentweapon,9999,"right");
            }
            else
            {
                self setWeaponAmmoClip(currentWeapon,9999);
            }
            self GiveMaxAmmo(currentWeapon);
        }
        currentoffhand = self GetCurrentOffhand();
        if(currentoffhand!="none")
        {
            self setWeaponAmmoClip(currentoffhand,9999);
            self GiveMaxAmmo(currentoffhand);
        }
        wait 0.05;
    } 
}


//Invisible
ToggleInvisible()
{
    if(self.pix_invisible)
    {
        self.pix_invisible = false;
        self iprintln("Invisible: ^1OFF");
        self show();
        return;
    }
    self.pix_invisible = true;
    self iprintln("Invisible: ^1ON");
    self hide();
}


//Clone Stuff Start
CreateClone(type = "default")
{
    if(type == "default")
    {
        clone = self clonePlayer(99999);
        clone thread removeEntityOverTime(60);
    }
    else if(type == "dead")
    {
        clone = self ClonePlayer(99999);
        clone startRagDoll();
        clone thread removeEntityOverTime(60);
    }
    else if(type == "follow")
    {
        if(!self.Clone_Follow)
        {
            self.Clone_Follow = true;
            self thread createTheStalkingClone();
        }
        else
        {
            self.Clone_Follow = false;
        }
    }
}
createTheStalkingClone()//Not good but its not ai zombies so i dont care
{
    player_body_model = self.model;
    player_head_model = self getAttachModelName(0);
    target            = self;
    
    //Body
    clone = spawn("script_model",self.origin);
    clone setModel(player_body_model);
    
    //Head
    clone.head = spawn("script_model",clone getTagOrigin("j_spine4"));
    clone.head setModel(player_head_model);
    clone.head.angles = (270,0,270);
    clone.head linkto(clone,"j_spine4");
    
    clone.currentsurface = "default";
    clone.targetname     = "clone";
    clone.classname      = "clone";
    clone.currentAnim    = "";//idle,walk,run,sprint
    clone.speed          = 0;
    
    
    while(self.Clone_Follow)
    {
        //Anim + Speed
        distanceToTarget = distance(clone.origin,target.origin);
        if(distanceToTarget >= 250 && distanceToTarget < 350)
        {
            if(clone.currentAnim!="walk")
            {
                clone.currentAnim = "walk";
                clone.Speed       = 5.0;
                clone scriptModelPlayAnim("pb_walk_forward_akimbo");
            }
        }
        else if(distanceToTarget >= 350 && distanceToTarget < 500)
        {
            if(clone.currentAnim!="run")
            {
                clone.currentAnim = "run";
                clone.Speed       = 10.0;
                clone scriptModelPlayAnim("pb_run_fast");
            }
        }
        else if(distanceToTarget >= 500)
        {
            if(clone.currentAnim!="sprint")
            {
                clone.currentAnim = "sprint";
                clone.Speed       = 15.0;
                clone scriptModelPlayAnim("pb_sprint_akimbo");
            }
        }
        else
        {
            if(clone.currentAnim!="idle")
            {
                clone.currentAnim = "idle";
                clone.Speed       = 0;
                clone notify("clone_move_done");
                clone scriptModelPlayAnim("pb_stand_alert");
            }
        }
        
        
        //Move
        clone clone_move(target.origin);
        
        wait 0.05;
    }
    clone delete();
    clone.head delete();
}
clone_move(targetPos)
{
    self notify("clone_move_done");
    self endon("clone_move_done");
    self clone_clampToGround();
    pos          = self.origin;
    target_pos   = targetPos;
    vec3_normal  = VectorNormalize(target_pos - self.origin);
    vec3_angles  = VectorToAngles(target_pos - self getTagOrigin("j_head"));
    moveToLoc    = pos + (vec3_normal*self.Speed);
    rotate_angle = VectorToAngles(target_pos - self getTagOrigin("j_head"));
    self.origin  = moveToLoc;
    self RotateTo((0,rotate_angle[1],0),0.1);
    self notify("clone_move_done");
}
clone_clampToGround()
{
    trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,self);
    if(isdefined(trace["entity"])&&isDefined(trace["entity"].targetname)&&trace["entity"].targetname=="clone")
    {
        trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,trace["entity"]);
    }
    self.currentsurface = trace["surfacetype"];
    if(self.currentsurface=="none")
    {
        self.currentsurface = "default";
    }
    if((trace["position"][2]-(self.origin[2]-40))>0&&((self.origin[2]+50)-trace["position"][2])>0)
    {
        self.origin = trace["position"];
        return true;
    }
    return false;
}
//Clone Stuff End


//Teleport
TeleportToSelectedPos()
{
    self _closeMenu();
    wait .2;
    self setMenuVar("locked",true);
    self beginLocationSelection("map_artillery_selector",true,(level.mapSize/5.625));
    self.selectingLocation = true;
    self waittill("confirm_location",location,directionYaw);
    newLocation = BulletTrace(location,(location+(0,0,-1000)),0,self)["position"];
    self SetOrigin(newLocation);
    self SetPlayerAngles(directionYaw);
    self endLocationSelection();
    self.selectingLocation = undefined;
    self setMenuVar("locked",false);
    self _openMenu();
    wait .2;
}


//Go To Space
GoToSpace()
{
    if(self.isGoingToSpace)
    {
        return;
    }
    self.isGoingToSpace = true;
    self endon("death");
    for(i=5;i>0;i--)
    {
        self iprintlnBold("Take Off in: ^1"+i);
        wait 1;
    }
    self iprintlnBold("^1TAKE OFF!");
    self.rocket = spawn("script_origin",self.origin);
    self playerLinkTo(self.rocket);
    wait 0.05;
    self.rocket MoveTo(self.rocket.origin+(0,0,60000),18,5,5);
    wait 18;
    self unlink();
    self.rocket delete();
    wait 0.05;
    self.isGoingToSpace = false;
}


//Flashy Dude
ToggleFlashyDude()
{
    if(self.pix_flashy_dude)
    {
        self.pix_flashy_dude = false;
        wait .2;
        self iprintln("Flashy Dude: ^1OFF");
        self show();
        return;
    }
    self.pix_flashy_dude = true;
    while(self.pix_flashy_dude)
    {
        self hide();
        wait .1;
        self show();
        self iprintln("^"+randomInt(9)+" You are Flashing!");
        wait 0.05;
    }
}


//Gun Side
StageGunSide()
{
    self.GunSideVal ++;
    if(self.GunSideVal>4)
    {
        self.GunSideVal = 1;
    }
    if(self.GunSideVal==1)
    {
        self.GunSideShow = @"Default";
        self setClientDvar("cg_gun_y",0);
        self setClientDvar("cg_gun_x",0);
        self notify("endon_MoveGun");
    }
    if(self.GunSideVal==2)
    {
        self.GunSideShow = @"Left";
        self setClientDvar( "cg_gun_y",5);
        self setClientDvar( "cg_gun_x",0);
        self notify("endon_MoveGun");
    }
    if(self.GunSideVal==3)
    {
        self.GunSideShow = @"Right";
        self setClientDvar( "cg_gun_y",-5);
        self setClientDvar( "cg_gun_x",0);
        self notify("endon_MoveGun");
    }
    if(self.GunSideVal==4)
    {
        self.GunSideShow = @"Moving";
        self thread MoveGun();
    }
    self _scrollMenu("text_update");
}
MoveGun()
{
    self endon ("endon_MoveGun");
    self setClientDvar("cg_gun_y",0);
    self setClientDvar("cg_gun_x",10);
    i = -30;
    for(;;)
    {
        i++;
        self setClientDvar("cg_gun_y",i);
        if(getDvar("cg_gun_y")=="30")
        {
            i=-30;
        }
        wait .1;
    }
}


//Viewport Scale
StageViewport()
{
    self.ViewPortVal ++;
    if(self.ViewPortVal>4)
    {
        self.ViewPortVal = 1;
    }
    if(self.ViewPortVal==1)
    {
        self.ViewPortShow = @"Default";
        self ViewPortScaleChange("Fullscreen");
    }
    if(self.ViewPortVal==2)
    {
        self.ViewPortShow = @"0.5";
        self ViewPortScaleChange("0.5");
    }
    if(self.ViewPortVal==3)
    {
        self.ViewPortShow = @"0.3";
        self ViewPortScaleChange("0.3");
    }
    if(self.ViewPortVal==4)
    {
        self.ViewPortShow = @"0.1";
        self ViewPortScaleChange("NotFullscreen");
    }
    self _scrollMenu("text_update");
}
ViewPortScaleChange(type)
{
    switch(type)
    {
        case "Fullscreen":
            self setClientDvar("r_scaleviewport",0.2);wait 0.05;
            self setClientDvar("r_scaleviewport",0.3);wait 0.05;
            self setClientDvar("r_scaleviewport",0.4);wait 0.05;
            self setClientDvar("r_scaleviewport",0.5);wait 0.05;
            self setClientDvar("r_scaleviewport",0.6);wait 0.05;
            self setClientDvar("r_scaleviewport",0.7);wait 0.05;
            self setClientDvar("r_scaleviewport",0.8);wait 0.05;
            self setClientDvar("r_scaleviewport",0.9);wait 0.05;
            self setClientDvar("r_scaleviewport",1);wait 0.05;
        break;
          
        case "NotFullscreen":
            self setClientDvar("r_scaleviewport",0.2);wait 0.05;
            self setClientDvar("r_scaleviewport",0.1);wait 0.05;
        break;
          
        case "0.5":
            self setClientDvar("r_scaleviewport",0.9);wait 0.05;
            self setClientDvar("r_scaleviewport",0.8);wait 0.05;
            self setClientDvar("r_scaleviewport",0.7);wait 0.05;
            self setClientDvar("r_scaleviewport",0.6);wait 0.05;
            self setClientDvar("r_scaleviewport",0.5);wait 0.05;
        break;
          
        case "0.3":
            self setClientDvar("r_scaleviewport",0.4);wait 0.05;
            self setClientDvar("r_scaleviewport",0.3);wait 0.05;
        break;
    }
}


//Set Rank
setRank_GSC(client,rank_num)
{
    client setPlayerData("experience",getRankXpValue(rank_num));
    client thread maps\mp\gametypes\_rank::scorePopup(10,getRankXpValue(rank_num),(1,1,1),0);
    client maps\mp\gametypes\_hud_message::oldNotifyMessage("Ranked Up To",getRankString(rank_num),getRankShader(rank_num),(0,0,0),"mp_level_up",7);
}
setRank_RPC(client,rank_num)
{
    selected_rank = level.RPC_ranks[rank_num];
    if(!isConsole())
    {
        RPC(0x588480, client GetEntityNumber(), 0, "J 2056 " + selected_rank + "; 2064 0B0");
    }
    else
    {
        if(isXbox())
        {
            RPC(0x822548D8, client GetEntityNumber(), 0, "J 2056 " + selected_rank + "; 2064 0B0");
        }
        else
        {
            RPC(0xDEADBEEF, client GetEntityNumber(), 0, "J 2056 " + selected_rank + "; 2064 0B0");
        }
    }
}

//Change Prestige
setPrestige(prestigeNum,client)
{
    if(prestigeNum==11) 
    {
        prestigeString = "J 2064 0B0";
    }
    if(prestigeNum==10) 
    {
        prestigeString = "J 2064 0A0";
    }
    else 
    {
        prestigeString = "J 2064 0" + prestigeNum + "0";
    }
    if(!isConsole())
    {
        RPC(0x588480, client getEntityNumber(), 0, prestigeString);
    }
    else
    {
        if(isXbox())
        {
            RPC(0x822548D8, client getEntityNumber(), 0, prestigeString);
        }
        else
        {
            client iprintlnBold("^1PS3 NOT SUPPORTED");
        }
    }
}