//Menu Var Functions
setMenuVar(var_name,var_input)
{
    if(!isDefined(self.PIX["Menu_Var"]))
    {
        self.PIX["Menu_Var"] = [];
    }
    self.PIX["Menu_Var"][var_name] = var_input;
}
getMenuVar(var_name)
{
    if(!isDefined(self.PIX["Menu_Var"][var_name]))
    {
        return undefined;
    }
    return self.PIX["Menu_Var"][var_name];
}
toggleMenuVar(var_name)
{
    if(!self getMenuVar(var_name))
    {
        self setMenuVar(var_name,true);
        if(var_name=="colorful_fog")
        {
            self.Hud["Fog_Scroll_1"] thread elemSmoothFlash();
            self.Hud["Fog_Stencil_1"] thread elemSmoothFlash();
            self.Hud["Fog_Scroll_2"] thread elemSmoothFlash();
            self.Hud["Fog_Stencil_2"] thread elemSmoothFlash();
        }
        if(var_name=="colorful_glow")
        {
            self.Hud["Corner_Glow"] thread elemSmoothFlash();
        }
    }
    else
    {
        self setMenuVar(var_name,false);
        if(var_name=="menu_freeze")
        {
            wait 0.05;
            self freezeControls(false);
        }
        if(var_name=="colorful_fog")
        {
            self.Hud["Fog_Scroll_1"] notify("end_smooth_flash");
            self.Hud["Fog_Scroll_1"].color = self.Hud["Fog_Scroll_1"].default_color;//(0.85,0.85,0.85);        
            self.Hud["Fog_Stencil_1"] notify("end_smooth_flash");
            self.Hud["Fog_Stencil_1"].color = self.Hud["Fog_Stencil_1"].default_color;//(1,1,1);
            self.Hud["Fog_Scroll_2"] notify("end_smooth_flash");
            self.Hud["Fog_Scroll_2"].color = self.Hud["Fog_Scroll_1"].default_color;//(0.85,0.85,0.85);
            self.Hud["Fog_Stencil_2"] notify("end_smooth_flash");
            self.Hud["Fog_Stencil_2"].color = self.Hud["Fog_Stencil_1"].default_color;//(1,1,1);
        }
        if(var_name=="colorful_glow")
        {
            self.Hud["Corner_Glow"] notify("end_smooth_flash");
            self.Hud["Corner_Glow"].color = self.Hud["Corner_Glow"].default_color;//(1,1,1)
        }
    }
}



//Set & Get Current Menu
setCurrentMenu(menu = "main")
{
    self.PIX["CurrentMenu"] = menu;
}
getCurrentMenu()
{
    if(!isDefined(self.PIX["CurrentMenu"]))
    {
        self setCurrentMenu("main");
    }
    return self.PIX["CurrentMenu"];
}


//Set & Get Current Menu Scroller
setMenuScroller(value,directSet=false)
{
    if(!directSet)
    {
        if(value<0)
        {
            if(self getCurrentMenuType()!="menu_ays")
            {
                self thread _autoScrollTo("bottom",0.05);
                return;
            }
            else
            {
                self.Scroller[self getCurrentMenu()] = self getMenuSize()-1;
                return;
            }
        }
        if(value>self getMenuSize()-1)
        {
            if(self getCurrentMenuType()!="menu_ays")
            {
                self thread _autoScrollTo("top",0.05);
                return;
            }
            else
            {
                self.Scroller[self getCurrentMenu()] = 0;
                return;
            }
        }
    }
    self.Scroller[self getCurrentMenu()] = value;
}
getMenuScroller()
{
    if(!isDefined(self.Scroller[self getCurrentMenu()]))
    {
        self setMenuScroller(0,true);
    }
    return self.Scroller[self getCurrentMenu()];
}




//Get Current Menu Type
getCurrentMenuType()
{
    if(!isDefined(self.Menu[self getCurrentMenu()].type))
    {
        self.Menu[self getCurrentMenu()].type = "default";
    }
    return self.Menu[self getCurrentMenu()].type;
}


//Get Current Menu Extra Space
getCurrentMenuExtraSpace()
{
    if(!isDefined(self.Menu[self getCurrentMenu()].extra_space))
    {
        self.Menu[self getCurrentMenu()].extra_space = 0;
    }
    if(self getCurrentMenuType()=="menu_ays")
    {
        if(isDefined(self getMenuVar("AYS_info")) && (self getMenuVar("AYS_info")!=""))
        {
            info   = strTok(self getMenuVar("AYS_info"),";");
            height = (info.size*20);
        }
        else
        {
            info   = undefined;
            height = 0;
        }
        space = height;
    }
    else if(self getCurrentMenuType()=="menu_ws")
    {
        space = 60;
    }
    else
    {
        space = self.Menu[self getCurrentMenu()].extra_space;
    }
    return space;
}

//Get Current Menu Size
getMenuSize()
{
    return (self.Menu[self getCurrentMenu()].text.size<=0) ? 0 : self.Menu[self getCurrentMenu()].text.size;
}

//Get Last added option ----- only for loadMenuStruct() stuff
getLatestOptionAdded()
{
    return (self getMenuSize()-1);
}

//Get Menu Option Index by string
getOptionIndexByString(string)
{
    foreach(index,text in self.Menu[self getCurrentMenu()].text)
    {
        if(text==string)
        {
            return index;
        }
    }
}



//Get Main Position for the menu ---- add custom defines later --- or maybe im not doing any custom stuff at all???
getMenuPosForAlign(pos_type="TOP_preDefined")//dont remove -- gets used for multiple stuff
{
    pos = spawnStruct();
    if(strip_suffix(pos_type,"_preDefined")=="TOP")
    {
        pos.x = 0;
        pos.y = 5;
    }
    else if(strip_suffix(pos_type,"_preDefined")=="TOP_LEFT")
    {
        pos.x = -160;
        pos.y = 5;
    }
    else if(strip_suffix(pos_type,"_preDefined")=="TOP_RIGHT")
    {
        pos.x = 190;
        pos.y = 5;
    }
    else if(strip_suffix(pos_type,"_preDefined")=="CENTER")
    {
        pos.x = 0;
        pos.y = 170;
    }
    else if(strip_suffix(pos_type,"_preDefined")=="CENTER_LEFT")
    {
        pos.x = -160;
        pos.y = 170;
    }
    else if(strip_suffix(pos_type,"_preDefined")=="CENTER_RIGHT")
    {
        pos.x = 190;
        pos.y = 170;
    }
    else
    {
        pos.x = 0;
        pos.y = 5;
    }
    return pos;
}

///Change Menu Position --- more simple then updating all the elem positions
changeMenuMainPos(pos_type)
{
    self _closeMenu();
    wait .2;
    self setMenuVar("menu_main_pos",pos_type);
    wait 0.05;
    self _openMenu();
}




//TableLookUp Stuff
getRankString(rank_num)
{
    return tableLookupIString("mp/rankTable.csv",0,rank_num,5);
}
getRankShader(rank_num)
{
    return tableLookup("mp/rankTable.csv",0,rank_num,6);
}
getRankXpValue(rank_num)
{
    return tableLookup("mp/rankTable.csv",0,rank_num,7);
}
getPrestigeShader(pres_num)
{
    return tableLookup("mp/rankIconTable.csv",0,0,1+pres_num);
}
getWeaponShader(base_weapon)
{
    tableRow  = tableLookup("mp/statstable.csv",4,base_weapon,0);
    weaponPic = tableLookup("mp/statsTable.csv",0,tableRow,6);
    return weaponPic;
}
getWeaponNameString(base_weapon)
{
    tableRow         = tableLookup("mp/statstable.csv",4,base_weapon,0);
    weaponNameString = tableLookupIString("mp/statstable.csv",0,tableRow,3);
    return weaponNameString;
}
getAttachmentShader(attachmentId)
{
    tableRow      = tableLookup("mp/attachmentTable.csv",4,attachmentId,0);
    attachmentPic = tableLookup("mp/attachmentTable.csv",0,tableRow,6);
    return attachmentPic;
}
getAttachmentNameString(attachmentId)
{
    tableRow             = tableLookup("mp/attachmentTable.csv",4,attachmentId,0);
    attachmentNameString = tableLookupIString("mp/attachmentTable.csv",0,tableRow,3);
    return attachmentNameString;
}
getAttachmentList(base_weapon)
{
    list     = [];
    tableRow = tableLookup("mp/statstable.csv",4,base_weapon,0);
    for(i=0;i<10;i++)
    {
        attachment = tableLookup("mp/statsTable.csv",0,tableRow,11+i);
        for(l=0;l<level.pix_attachmentList.size;l++)
        {
            if((attachment!="") && (attachment==level.pix_attachmentList[l].id))
            {
                size = list.size;
                list[size] = attachment;
            }
        }
    }
    return list;
}
getCamoNumber(camoId)
{
    camoNumber = tableLookup("mp/camoTable.csv",1,camoId,0);
    return camoNumber;
}
getCamoShader(camoId)
{
    camoPic = tableLookup("mp/camoTable.csv",1,camoId,4);
    return camoPic;
}
getCamoNameString(camoId)
{
    camoNameString = tableLookupIString("mp/camoTable.csv",1,camoId,2);
    return camoNameString;
}
getPerkId(perk_number)
{
    return tableLookup("mp/perkTable.csv",0,perk_number,1);
}
getPerkShader(perk_id)
{
    return tableLookup("mp/perkTable.csv",1,perk_id,3);
}
getPerkString(perk_id)
{
    return tableLookupIString("mp/perkTable.csv",1,perk_id,2);
}
getPerkDescString(perk_id)
{
    return tableLookupIString("mp/perkTable.csv",1,perk_id,4);
}
getProPerkId(default_perk_id)
{
    return tableLookup("mp/perkTable.csv",1,default_perk_id,8);
}
getProPerkString(default_perk_id)
{
    return tableLookupIString("mp/perkTable.csv",1,default_perk_id,9);
}




//Weapon Selector Confirm Functions
weaponSelectorConfirmSelection_Weapon(weaponId)
{
    self setMenuVar("ws_confirmed_weapon",weaponId);
    self setMenuVar("ws_destroy_hud_on_menu_load",false);
    self _loadMenu("ws_attachment_menu");
}
weaponSelectorConfirmSelection_Attachment(attachmentId)
{
    self setMenuVar("ws_confirmed_attachment",attachmentId);
    weapon = self getMenuVar("ws_confirmed_weapon");
    if(getWeaponClass(weapon+"_mp") == "weapon_smg"||getWeaponClass(weapon+"_mp") == "weapon_assault"||getWeaponClass(weapon+"_mp") == "weapon_sniper"||getWeaponClass(weapon+"_mp") == "weapon_lmg")
    {
        self setMenuVar("ws_destroy_hud_on_menu_load",false);
        self _loadMenu("ws_camo_menu");
    }
    else
    {
        self weaponSelector_giveWeapon(self getMenuVar("ws_confirmed_weapon"),self getMenuVar("ws_confirmed_attachment"),self getMenuVar("ws_confirmed_camo"));
    }
}
weaponSelectorConfirmSelection_Camo(camoId)
{
    self setMenuVar("ws_confirmed_camo",camoId);
    self weaponSelector_giveWeapon(self getMenuVar("ws_confirmed_weapon"),self getMenuVar("ws_confirmed_attachment"),self getMenuVar("ws_confirmed_camo"));
}
weaponSelector_giveWeapon(weaponId = "none",attachmentId = "none",camoId = "none")
{
    if(weaponId!="none")
    {
        if(attachmentId=="none")
        {
            weapon = weaponId + "_mp";
        }
        else
        {
            weapon = weaponId + "_" + attachmentId + "_mp";
        }
        if(attachmentId=="akimbo")
        {
            self _giveWeapon(weapon,int(getCamoNumber(camoId)),true);
        }
        else
        {
            self _giveWeapon(weapon,int(getCamoNumber(camoId)));
        }
        self freezeControls(false);
        self switchToWeapon(weapon);
        self _loadMenu("ws_main_menu");
    }
}





//Cursor Controlling not added right now ---- and im probably not even going to try to add it soon
/*
//cursor controller 
//add start_angles,start_stance and cursor max/min position vars to use it
//everything else should be obvious
menuCursorController()
{
    self endon("disconnect");
    self endon("Remove_Menu");
    
    
    if(!isDefined(self.Hud["Cursor"]))
    {
        self.Hud["Cursor"] = createRectangle("CENTER","CENTER",0,0,5,5,(1,0,0),1,"white");
        self.Hud["Cursor"] elemSetSort(666);
    }
    
    while(self getMenuVar("opened") && isDefined(self.Hud["Cursor"]))
    {
        //Cursor Logic
        x_diff = self getPlayerAngles()[1] - self getMenuVar("start_angles")[1];
        y_diff = self getPlayerAngles()[0] - self getMenuVar("start_angles")[0];
        self.Hud["Cursor"].x = ((self.Hud["Cursor"].x - x_diff) >= 0) ? (((self.Hud["Cursor"].x - x_diff) > self getMenuVar("max_cursor_x_pos")) ? self getMenuVar("max_cursor_x_pos") : (self.Hud["Cursor"].x - x_diff)) : (((self.Hud["Cursor"].x - x_diff) < self getMenuVar("min_cursor_x_pos")) ? self getMenuVar("min_cursor_x_pos") : (self.Hud["Cursor"].x - x_diff));
        self.Hud["Cursor"].y = ((self.Hud["Cursor"].y + y_diff) >= 0) ? (((self.Hud["Cursor"].y + y_diff) > self getMenuVar("max_cursor_y_pos")) ? self getMenuVar("max_cursor_y_pos") : (self.Hud["Cursor"].y + y_diff)) : (((self.Hud["Cursor"].y + y_diff) < self getMenuVar("min_cursor_y_pos")) ? self getMenuVar("min_cursor_y_pos") : (self.Hud["Cursor"].y + y_diff));
        self setPlayerAngles(self getMenuVar("start_angles"));
        wait 0.05;//0.01 is too fast
    }
}

//cursor controller collision detection ---- needs updating for this menu
isButtonHovered(button)
{
    if(!isDefined(self.Hud["Cursor"]))
    {
        return;
    }
    
    //Y axis -- all i need right now
    button_check_y_n = button.y - (button.height/2);
    button_check_y_p = button.y + (button.height/2);
    
    
    //X axis -- all i need right now
    if(button.align=="CENTER" && button.relative=="CENTER")
    {
        button_check_x_n = button.x - (button.width/2);
        button_check_x_p = button.x + (button.width/2);
    }
    else if(button.align=="LEFT" && button.relative=="CENTER")
    {
        button_check_x_n = (button.x + (button.width/2)) - (button.width/2);
        button_check_x_p = (button.x + (button.width/2)) + (button.width/2);
    }
    else if(button.align=="RIGHT" && button.relative=="CENTER")
    {
        button_check_x_n = (button.x - (button.width/2)) - (button.width/2);
        button_check_x_p = (button.x - (button.width/2)) + (button.width/2);
    }
    else
    {
        return false;
    }
    
    
    //check if the cursor is not in the button bg rect
    if((self.Hud["Cursor"].x <= button_check_x_n) || (self.Hud["Cursor"].x >= button_check_x_p) || (self.Hud["Cursor"].y <= button_check_y_n) || (self.Hud["Cursor"].y >= button_check_y_p))
    {
        return false;
    }
    return true;
}
*/