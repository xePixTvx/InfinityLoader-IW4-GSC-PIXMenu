loadMenuStruct()
{
    self thread mainMenuStruct();
    self thread loadDeveloperMenus();
    self thread perkMenuStruct();
    self thread weaponSelectorStruct();
    if(self getVerifycationLevel()>=4)
    {
        self thread playerMenuStruct();
    }
}


mainMenuStruct()
{
    //Main Menu
    if(self getCurrentMenu()=="main")
    {
        self CreateMenu("main","P!X V"+MENU_VERSION,"Exit");
        if(level.pixMenuDeveloperMode)
        {
            self loadMenu(-1,"main","Sub Menu[^1DEV^7]","sub");
            self loadMenu(-1,"main","Sub Menu 2[^1DEV^7]","sub2");
            self loadMenu(-1,"main","UNLM SCROLL MENU[^1DEV^7]","sub_unlm_scroll");
            self addToggleOption(-1,"main","Toggle Test[^1DEV^7]",::TestToggle,self.TestToggle);
        }
        self loadMenu(-1,"main","Menu Settings","menu_sets");
        self addOption(-1,"main",@"Suicide",::killClient,self);
        self loadMenu(-1,"main","Main Mods","main_mods");
            self addVerifycation(self getLatestOptionAdded(),"main",1);
        self loadMenu(-1,"main","Weapon Menu","main_weapon_main_menu");
        self addOption(-1,"main","Option 7",::Test);
        self addOption(-1,"main","Option 8",::Test);
        self addOption(-1,"main","Option 9",::Test);
        self addOption(-1,"main","Option 10",::Test);
        self loadMenu(-1,"main",@"Players","players_menu");
            self addVerifycation(self getLatestOptionAdded(),"main",4);
    }
        
    //AYS Base --- DONT REMOVE!!!!!!!!!!!
    if(self getCurrentMenu()=="ays_base")
    {
        self CreateMenu("ays_base","Are You Sure?",self getMenuVar("AYS_parent"),"menu_ays");
        self addOption(-1,"ays_base","YES",self getMenuVar("AYS_func"),self getMenuVar("AYS_inp1"),self getMenuVar("AYS_inp2"),self getMenuVar("AYS_inp3"));
        self loadMenu(-1,"ays_base",@"NO",self getMenuVar("AYS_parent"));
    }
    
    
    
    //Menu Settings
    if(self getCurrentMenu()=="menu_sets")
    {
        self CreateMenu("menu_sets","Menu Settings","main");
        self addToggleOption(-1,"menu_sets","Menu Freeze",::toggleMenuVar,self getMenuVar("menu_freeze"),"menu_freeze");
        self addToggleOption(-1,"menu_sets","Menu Sounds",::toggleMenuVar,self getMenuVar("menu_sounds"),"menu_sounds");
        self addToggleOption(-1,"menu_sets","Colorful Fog",::toggleMenuVar,self getMenuVar("colorful_fog"),"colorful_fog");
        self addToggleOption(-1,"menu_sets","Colorful Glow",::toggleMenuVar,self getMenuVar("colorful_glow"),"colorful_glow");
        self loadMenu(-1,"menu_sets","Change Menu Position","main_menu_pos");
    }
        //Change Menu Position
        if(self getCurrentMenu()=="main_menu_pos")
        {
           self CreateMenu("main_menu_pos","Menu Position","menu_sets");
           self loadMenu(-1,"main_menu_pos","Predefined Positions","main_menu_pos_pre");
           self addOption(-1,"main_menu_pos","Custom Positions[^1Coming Soon^7]",::Test,"^1Coming Soon!");
        }
        
        //Predefined Menu Positions
        if(self getCurrentMenu()=="main_menu_pos_pre")
        {
            self CreateMenu("main_menu_pos_pre","Predefined Positions","main_menu_pos");
            self addToggleOption(-1,"main_menu_pos_pre","TOP",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="TOP_preDefined","TOP_preDefined");
            self addToggleOption(-1,"main_menu_pos_pre","TOP LEFT",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="TOP_LEFT_preDefined","TOP_LEFT_preDefined");
            self addToggleOption(-1,"main_menu_pos_pre","TOP RIGHT",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="TOP_RIGHT_preDefined","TOP_RIGHT_preDefined");
            self addToggleOption(-1,"main_menu_pos_pre","CENTER",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="CENTER_preDefined","CENTER_preDefined");
            self addToggleOption(-1,"main_menu_pos_pre","CENTER LEFT",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="CENTER_LEFT_preDefined","CENTER_LEFT_preDefined");
            self addToggleOption(-1,"main_menu_pos_pre","CENTER RIGHT",::changeMenuMainPos,self getMenuVar("menu_main_pos")=="CENTER_RIGHT_preDefined","CENTER_RIGHT_preDefined");
        }
    
        
        
    //Main Mods
    if(self getCurrentMenu()=="main_mods")
    {
        self CreateMenu("main_mods","Main Mods","main");
        self addAysOption(-1,"main_mods","Max Rank",::setRank_GSC,"Set Rank To ^170^7",self,69);
        self loadMenu(-1,"main_mods","Change Rank","main_rank_menu");
        self loadMenu(-1,"main_mods","Change Prestige","main_prestige_menu");
        self addToggleOption(-1,"main_mods","Godmode",::ToggleGodMode,self.pix_godmode);
        self addToggleOption(-1,"main_mods","Unlimited Ammo",::ToggleUnlimitedAmmo,self.pix_unlm_ammo);
        self addToggleOption(-1,"main_mods",@"Invisible",::ToggleInvisible,self.pix_invisible);
        self loadMenu(-1,"main_mods","Clone Menu","main_clone_menu");
        self addOption(-1,"main_mods","Teleport",::TeleportToSelectedPos);
        self addOption(-1,"main_mods","Go To Space",::GoToSpace);
        self addToggleOption(-1,"main_mods","Flashy Dude",::ToggleFlashyDude,self.pix_flashy_dude);
        self loadMenu(-1,"main_mods","Perk Menu","main_perk_menu");
        self addOption(-1,"main_mods","Gun Side["+self.GunSideShow+"]",::StageGunSide);
        self addOption(-1,"main_mods","Viewport Scale["+self.ViewPortShow+"]",::StageViewport);
    }
        
        //Rank Menu
        if(self getCurrentMenu()=="main_rank_menu")
        {
            self CreateMenu("main_rank_menu","Rank Menu","main_mods","pic");
            self addPictureMenuInfos("main_rank_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<70;i++)
            {
                ays_string_number = i+1;
                self addAysOption(i,"main_rank_menu",getRankString(i),::setRank_RPC,"Set Rank To ^1"+ays_string_number+"^7;This will kick you out of the game!",self,i);
                self addPictureOptionInfos(i,"main_rank_menu",getRankShader(i));
            }
        }
        
        //Prestige Menu
        if(self getCurrentMenu()=="main_prestige_menu")
        {
            self CreateMenu("main_prestige_menu","Prestige Menu","main_mods","pic");
            self addPictureMenuInfos("main_prestige_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<=11;i++)
            {
                self addAysOption(i,"main_prestige_menu",@"Prestige"+i,::setPrestige,"Set Prestige To ^1"+i+"^7;This will kick you out of the game!",i,self);
                self addPictureOptionInfos(i,"main_prestige_menu",(i>=11) ? "rank_prestige11" : getPrestigeShader(i));
            }
        }
        
        //Clone Menu
        if(self getCurrentMenu()=="main_clone_menu")
        {
            self CreateMenu("main_clone_menu","Clone Menu","main_mods");
            self addOption(-1,"main_clone_menu",@"Default",::CreateClone);
            self addOption(-1,"main_clone_menu",@"Dead",::CreateClone,"dead");
            self addToggleOption(-1,"main_clone_menu","Follow",::CreateClone,self.Clone_Follow,"follow");
        }
        
        
        //Weapon Menu
        if(self getCurrentMenu()=="main_weapon_main_menu")
        {
            self CreateMenu("main_weapon_main_menu","Weapon Menu","main");
            self loadMenu(-1,"main_weapon_main_menu","Give Weapon","ws_main_menu");
            self addOption(-1,"main_weapon_main_menu","op 2",::Test);
            //self addOption(-1,"main_weapon_main_menu","op 3",::Test);
        }
}
    
perkMenuStruct()
{
    //Perk Menu
    if(self getCurrentMenu()=="main_perk_menu")
    {
        self CreateMenu("main_perk_menu","Perk Menu","main_mods");
        self loadMenu(-1,"main_perk_menu",&"MENU_PERK1_CAPS","main_perk_tier1_menu");
        self loadMenu(-1,"main_perk_menu",&"MENU_PERK2_CAPS","main_perk_tier2_menu");
        self loadMenu(-1,"main_perk_menu",&"MENU_PERK3_CAPS","main_perk_tier3_menu");
        self addOption(-1,"main_perk_menu","Clear Perks",::clearPerksCustom);
    }
    
        //Perk Menu --- Tier 1
        if(self getCurrentMenu()=="main_perk_tier1_menu")
        {
            self CreateMenu("main_perk_tier1_menu",&"MENU_PERK1_CAPS","main_perk_menu");
            self loadMenu(-1,"main_perk_tier1_menu",@"Default","perk_tier1_default_menu");
            self loadMenu(-1,"main_perk_tier1_menu","Pro","perk_tier1_pro_menu");
        }
            
        //Tier 1 - Default
        if(self getCurrentMenu()=="perk_tier1_default_menu")
        {
            self CreateMenu("perk_tier1_default_menu","Default Perks","main_perk_tier1_menu","pic");
            self addPictureMenuInfos("perk_tier1_default_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[1].size;i++)
            {
                self addToggleOption(i,"perk_tier1_default_menu",getPerkString(level.perk_tier[1][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[1][i]),level.perk_tier[1][i]);
                self addPictureOptionInfos(i,"perk_tier1_default_menu",getPerkShader(level.perk_tier[1][i]));
            }
        }
        //Tier 1 - Pro
        if(self getCurrentMenu()=="perk_tier1_pro_menu")
        {
            self CreateMenu("perk_tier1_pro_menu","Pro Perks","main_perk_tier1_menu","pic");
            self addPictureMenuInfos("perk_tier1_pro_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[1].size;i++)
            {
                self addToggleOption(i,"perk_tier1_pro_menu",getProPerkString(level.perk_tier[1][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[1][i],"pro"),level.perk_tier[1][i],"pro");
                self addPictureOptionInfos(i,"perk_tier1_pro_menu",getPerkShader(getProPerkId(level.perk_tier[1][i])));
            }
        }
        
        //Perk Menu --- Tier 2
        if(self getCurrentMenu()=="main_perk_tier2_menu")
        {
            self CreateMenu("main_perk_tier2_menu",&"MENU_PERK2_CAPS","main_perk_menu");
            self loadMenu(-1,"main_perk_tier2_menu",@"Default","perk_tier2_default_menu");
            self loadMenu(-1,"main_perk_tier2_menu","Pro","perk_tier2_pro_menu");
        }
            
        //Tier 2 - Default
        if(self getCurrentMenu()=="perk_tier2_default_menu")
        {
            self CreateMenu("perk_tier2_default_menu","Default Perks","main_perk_tier2_menu","pic");
            self addPictureMenuInfos("perk_tier2_default_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[2].size;i++)
            {
                self addToggleOption(i,"perk_tier2_default_menu",getPerkString(level.perk_tier[2][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[2][i]),level.perk_tier[2][i]);
                self addPictureOptionInfos(i,"perk_tier2_default_menu",getPerkShader(level.perk_tier[2][i]));
            }
        }
        //Tier 2 - Pro
        if(self getCurrentMenu()=="perk_tier2_pro_menu")
        {
            self CreateMenu("perk_tier2_pro_menu","Pro Perks","main_perk_tier2_menu","pic");
            self addPictureMenuInfos("perk_tier2_pro_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[2].size;i++)
            {
                self addToggleOption(i,"perk_tier2_pro_menu",getProPerkString(level.perk_tier[2][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[2][i],"pro"),level.perk_tier[2][i],"pro");
                self addPictureOptionInfos(i,"perk_tier2_pro_menu",getPerkShader(getProPerkId(level.perk_tier[2][i])));
            }
        }
        
        //Perk Menu --- Tier 3
        if(self getCurrentMenu()=="main_perk_tier3_menu")
        {
            self CreateMenu("main_perk_tier3_menu",&"MENU_PERK3_CAPS","main_perk_menu");
            self loadMenu(-1,"main_perk_tier3_menu",@"Default","perk_tier3_default_menu");
            self loadMenu(-1,"main_perk_tier3_menu","Pro","perk_tier3_pro_menu");
        }
            
        //Tier 3 - Default
        if(self getCurrentMenu()=="perk_tier3_default_menu")
        {
            self CreateMenu("perk_tier3_default_menu","Default Perks","main_perk_tier3_menu","pic");
            self addPictureMenuInfos("perk_tier3_default_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[3].size;i++)
            {
                self addToggleOption(i,"perk_tier3_default_menu",getPerkString(level.perk_tier[3][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[3][i]),level.perk_tier[3][i]);
                self addPictureOptionInfos(i,"perk_tier3_default_menu",getPerkShader(level.perk_tier[3][i]));
            }
        }
        //Tier 3 - Pro
        if(self getCurrentMenu()=="perk_tier3_pro_menu")
        {
            self CreateMenu("perk_tier3_pro_menu","Pro Perks","main_perk_tier3_menu","pic");
            self addPictureMenuInfos("perk_tier3_pro_menu",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+15,50,50,50);
            for(i=0;i<level.perk_tier[3].size;i++)
            {
                self addToggleOption(i,"perk_tier3_pro_menu",getProPerkString(level.perk_tier[3][i]),::setPerkCustom,self hasPerkCustom(level.perk_tier[3][i],"pro"),level.perk_tier[3][i],"pro");
                self addPictureOptionInfos(i,"perk_tier3_pro_menu",getPerkShader(getProPerkId(level.perk_tier[3][i])));
            }
        }
}

weaponSelectorStruct()
{
    //Main Menu
    if(self getCurrentMenu()=="ws_main_menu")
    {
        self CreateMenu("ws_main_menu","Select Weapon","main_weapon_main_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_MACHINE_PISTOLS_CAPS","ws_mp_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_SHOTGUNS_CAPS","ws_sg_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_HANDGUNS_CAPS","ws_hg_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_ROCKETS_CAPS","ws_rockets_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_ASSAULT_RIFLES_CAPS","ws_ar_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_SMGS_CAPS","ws_smg_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_LMGS_CAPS","ws_lmg_menu");
        self loadMenu(-1,"ws_main_menu",&"MENU_SNIPER_RIFLES_CAPS","ws_sr_menu");
        self addOption(-1,"ws_main_menu",&"MENU_RIOT_SHIELD_CAPS",::weaponSelector_giveWeapon,"riotshield");
    }
    
    
    //Weapon Class Menus
    self CreateMenu("ws_mp_menu",&"MENU_MACHINE_PISTOLS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_sg_menu",&"MENU_SHOTGUNS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_hg_menu",&"MENU_HANDGUNS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_rockets_menu",&"MENU_ROCKETS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_ar_menu",&"MENU_ASSAULT_RIFLES_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_smg_menu",&"MENU_SMGS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_lmg_menu",&"MENU_LMGS_CAPS","ws_main_menu","menu_ws");
    self CreateMenu("ws_sr_menu","Sniper Rifles","ws_main_menu","menu_ws");//MENU_SNIPER_RIFLES_CAPS
    
    for(i=0;i<level.pix_weaponList.size;i++)
    {
        //Machine Pistols
        if(self getCurrentMenu()=="ws_mp_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_machine_pistol")
            {
                self addOption(-1,"ws_mp_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Shotguns
        if(self getCurrentMenu()=="ws_sg_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_shotgun")
            {
                self addOption(-1,"ws_sg_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Pistols
        if(self getCurrentMenu()=="ws_hg_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_pistol")
            {
                self addOption(-1,"ws_hg_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Rockets
        if(self getCurrentMenu()=="ws_rockets_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_projectile")
            {
                if(level.pix_weaponList[i].id!="gl")
                {
                    self addOption(-1,"ws_rockets_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
                }
            }
        }
        
        //Assault Rifles
        if(self getCurrentMenu()=="ws_ar_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_assault")
            {
                self addOption(-1,"ws_ar_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Smgs
        if(self getCurrentMenu()=="ws_smg_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_smg")
            {
                self addOption(-1,"ws_smg_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Lmgs
        if(self getCurrentMenu()=="ws_lmg_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_lmg")
            {
                self addOption(-1,"ws_lmg_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
        
        //Snipers
        if(self getCurrentMenu()=="ws_sr_menu")
        {
            if(getWeaponClass(level.pix_weaponList[i].id+"_mp")=="weapon_sniper")
            {
                self addOption(-1,"ws_sr_menu",getWeaponNameString(level.pix_weaponList[i].id),::weaponSelectorConfirmSelection_Weapon,level.pix_weaponList[i].id);
            }
        }
    }
    
    //Attachment Menu
    if(self getCurrentMenu()=="ws_attachment_menu")
    {
        attachments = getAttachmentList(self getMenuVar("ws_confirmed_weapon"));
        self CreateMenu("ws_attachment_menu","ATTACHMENTS","ws_main_menu","menu_ws");
        self addOption(-1,"ws_attachment_menu",getAttachmentNameString("none"),::weaponSelectorConfirmSelection_Attachment,"none");
        for(i=0;i<attachments.size;i++)
        {
            self addOption(-1,"ws_attachment_menu",getAttachmentNameString(attachments[i]),::weaponSelectorConfirmSelection_Attachment,attachments[i]);
        }
    }
    
    //Camo Menu
    if(self getCurrentMenu()=="ws_camo_menu")
    {
        self CreateMenu("ws_camo_menu","CAMOS","ws_main_menu","menu_ws");
        for(i=0;i<level.pix_camoList.size;i++)
        {
            self addOption(-1,"ws_camo_menu",getCamoNameString(level.pix_camoList[i].id),::weaponSelectorConfirmSelection_Camo,level.pix_camoList[i].id);
        }
    }
}
    
    



//add player disconnected and connected/joined update??
playerMenuStruct()
{
    self CreateMenu("players_menu",@"Players","main");
    playerList = sortPlayerListByVerifycationLevel();
    for(i=0;i<playerList.size;i++)
    {
        player = playerList[i];
        name   = player getTrueName();
        menu   = name + "_player_menu";
        vlevel = player getVerifycationLevel();
        
        
        //Players
        if(self getCurrentMenu()=="players_menu")
        {
            self loadMenu(-1,"players_menu",getVerifycationLevel_Color(vlevel)+name,menu);
        }
        
        
        //Player Menu
        if(self getCurrentMenu()==menu)
        {
            self CreateMenu(menu,name,"players_menu");
            for(v=0;v<level.VerifycationLevels.size;v++)//level.VerifycationLevels.size-1 to hide the Host Option ---- enabled for testing
            {
                text = getVerifycationLevel_String(v);//with vlevel color??? --- looks weird cause of the toggle stuff
                self addToggleOption(-1,menu,text,::setPlayerVerifycationLevel,vlevel==v,player,v);
            }
            self addOption(-1,menu,"Kick",::kickClient,player);
            self addOption(-1,menu,@"Kill[^1Headshot^7]",::killClient,player,self);
            self addOption(-1,menu,@"Suicide",::killClient,player);
        }
    }
    
}













//Menus
CreateMenu(menu,title,parent,type="default")
{
    //Menu
    self.Menu[menu] = spawnStruct();
    self.Menu[menu].title = title;
    self.Menu[menu].parent = parent;
    self.Menu[menu].type = type;
    
    //Options
    self.Menu[menu].text = [];
    self.Menu[menu].func = [];
    self.Menu[menu].input1 = [];
    self.Menu[menu].input2 = [];
    self.Menu[menu].input3 = [];
    self.Menu[menu].toggle = [];
    self.Menu[menu].ays_info = [];
    self.Menu[menu].menuLoader = [];
}
addPictureMenuInfos(menu,x,y,w,h,space)
{
    self.Menu[menu].pos_x = x;
    self.Menu[menu].pos_y = y;
    self.Menu[menu].pic_width = w;
    self.Menu[menu].pic_height = h;
    self.Menu[menu].extra_space = space;
    self.Menu[menu].picture = [];
}





//Options
addOption(index,menu,text,func,inp1,inp2,inp3)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].func[index] = func;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].input2[index] = inp2;
    self.Menu[menu].input3[index] = inp3;
    self.Menu[menu].menuLoader[index] = false;
}
addToggleOption(index,menu,text,func,toggle,inp1,inp2,inp3)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].func[index] = func;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].input2[index] = inp2;
    self.Menu[menu].input3[index] = inp3;
    self.Menu[menu].menuLoader[index] = false;
    self.Menu[menu].toggle[index] = (isDefined(toggle)) ? toggle : undefined;
}
addAysOption(index,menu,text,func,info_text,inp1,inp2,inp3)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].func[index] = func;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].input2[index] = inp2;
    self.Menu[menu].input3[index] = inp3;
    self.Menu[menu].menuLoader[index] = true;
    self.Menu[menu].ays_info[index] = (isDefined(info_text)) ? info_text : undefined;
}
loadMenu(index,menu,text,inp1)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].menuLoader[index] = true;
}
addVerifycation(index,menu,min_vlevel)
{
    self.Menu[menu].min_verifycation_level[index] = min_vlevel;
}
addPictureOptionInfos(index,menu,option_shader)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].picture[index] = option_shader;
}








loadDeveloperMenus()
{
    //DEV MENUS START
    if(level.pixMenuDeveloperMode)
    {
        if(self getCurrentMenu()=="sub")
        {
            self CreateMenu("sub","Sub Menu","main");
            self addOption(-1,"sub","Sub Option 1",::Test);
            self addOption(-1,"sub","Settings Test",::Test);
            self addOption(-1,"sub","CMD_TEXT_SMOOTH_FLASH.....CMD TEST",::Test);
            self addOption(-1,"sub","Spawn TestClient",::spawnTestClient);
            self addOption(-1,"sub","Sub Option 5",::Test);
            //self loadMenu(-1,"sub","Test Menu Positions","dev_predef_menupos"); ---- added to menu settings menu
            self addOption(-1,"sub","String Overflow + Fix",::OverFlowTest,true);
            self addOption(-1,"sub","String Overflow",::OverFlowTest,false);
            self addOption(-1,"sub","Sub Option 9",::Test);
            self addOption(-1,"sub","Sub Option 10",::Test);
            /*self addOption(-1,"sub","Test Extra Space: Default",::changeMenuExtraSpace,0); ------ removed cause menu does it automatically now
            self addOption(-1,"sub","Test Extra Space: 30",::changeMenuExtraSpace,30);
            self addOption(-1,"sub","Test Extra Space: 50",::changeMenuExtraSpace,50);
            self addOption(-1,"sub","Test Extra Space: 100",::changeMenuExtraSpace,100);*/
            self addOption(-1,"sub","Sub Option 17",::Test);
            self addOption(-1,"sub","Sub Option 18",::Test);
            self addToggleOption(-1,"sub","Toggle Test",::TestToggle,self.TestToggle);
            self addOption(-1,"sub","Sub Option 20",::Test);
            self addOption(-1,"sub","Sub Option 21",::Test);
            self addOption(-1,"sub","Sub Option 22",::Test);
            self addOption(-1,"sub","Sub Option 23",::Test);
            self addOption(-1,"sub","Sub Option 24",::Test);
            self addOption(-1,"sub","Sub Option 25",::Test);
        }
        
        if(self getCurrentMenu()=="sub2")
        {
            self CreateMenu("sub2","Sub Menu 2","main");
            self addOption(-1,"sub2","Sub Option 1",::Test);
            self addOption(-1,"sub2","Sub Option 2",::Test);
            self addAysOption(-1,"sub2","AYS Test[3 Lines]",::Test,"This is AYS Test!;Next Line Test;Even more Lines Test","^1AYS ^2INPUT ^5TEST ^4YAY");
            self addAysOption(-1,"sub2","AYS Test[6 Lines]",::Test,"This is AYS Test!;Next Line Test;Even more Lines Test;YAY BLABLA;MORE LINEEEESSSS;Enough for now xD","^1AYS ^2INPUT ^5TEST ^4YAY");
            self addAysOption(-1,"sub2","AYS Test[0 Lines]",::Test,"","^1AYS ^2INPUT ^5TEST ^4YAY");
        }
        
        if(self getCurrentMenu()=="sub_unlm_scroll")
        {
            self CreateMenu("sub_unlm_scroll","UNLM SCROLL","main");
            for(i=0;i<200;i++)
            {
                self addOption(-1,"sub_unlm_scroll","Scroll Option "+i,::Test);
            }
        }
    }
    //DEV MENUS END
}