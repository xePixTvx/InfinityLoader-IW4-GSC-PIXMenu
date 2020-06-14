#define UNLM_SCROLL_MAX = 5;
#define UNLM_SCROLL_MAX_HALF = 2;
#define UNLM_SCROLL_MAX_HALF_ONE = 3;
#define BG_FOG_SPEED = 32;//32 = default


//Setup Menu Stuff
_setupMenu()
{
    self.PIX                    = [];
    self.Menu                   = [];
    self.Scroller               = [];
    self.hasMenu                = false;
    self.AccessInfoMSG_isActive = false;
    
    self.TestToggle = false;//Test Bool
    
    //Menu Main Pos --- not finished so you shouldnt edit it
    self setMenuVar("menu_main_pos","TOP_RIGHT_preDefined");//default = TOP_RIGHT_preDefined
    
    //Extra Height Space --- dont edit
    self setMenuVar("menu_extra_space",0);
    
    //Menu Scrollbar(Vertical) vars --- dont edit
    self setMenuVar("menu_scrollbar_CURRENT_THUMB_SIZE",0);
    self setMenuVar("menu_scrollbar_CURRENT_MAX_TOP_POS",0);
    
    //Menu Weapon Selector --- dont edit
    self setMenuVar("ws_destroy_hud_on_menu_load",true);
    self setMenuVar("ws_confirmed_weapon","none");
    self setMenuVar("ws_confirmed_attachment","none");
    self setMenuVar("ws_confirmed_camo","none");
    
    
    //Menu Freeze --- feel free to edit
    self setMenuVar("menu_freeze",true);
    
    //Menu Sounds --- feel free to edit
    self setMenuVar("menu_sounds",true);
    
    //Colorful Fog --- feel free to edit
    self setMenuVar("colorful_fog",false);
    
    //Colorful Glow --- feel free to edit
    self setMenuVar("colorful_glow",false);
    
    //load menu struct(main menu)
    self loadMenuStruct();
}


//Give Menu to Player
giveMenu()
{
    if(!self.hasMenu)
    {
        self thread initMenu();
        self.hasMenu = true;
    }
}

//Remove Menu from Player
removeMenu()
{
    if(self.hasMenu)
    {
        if(self getMenuVar("opened"))
        {
            self _closeMenu();
            wait .2;
        }
        self notify("Remove_Menu");
        self.hasMenu = false;
    }
}


//Start Menu
initMenu()
{
    self freezeControls(false);
    self setMenuVar("menu_controls","menu");//menu
    self setMenuVar("menu_autoScrollTime",undefined);
    self setMenuVar("opened",false);
    self setMenuVar("locked",false);
    self.PIX["CurrentMenu"] = undefined;
    self thread menuMain();
}


//Menu Main Loop
menuMain()
{
    self endon("disconnect");
    self endon("Remove_Menu");
    for(;;)
    {
        if(!self getMenuVar("opened") && !self getMenuVar("locked"))
        {
            if(self MeleeButtonPressed() && self AdsButtonPressed())
            {
                self _openMenu();
                wait .4;
            }
        }
        else if(self getMenuVar("opened") && !self getMenuVar("locked"))
        {
            if(self getMenuVar("menu_freeze"))
            {
                self freezeControls(true);
            }
            if(self getMenuVar("menu_controls")=="menu")
            {
                self _menuControls();
            }
            else
            {
                self _restartMenu("^1UNKNOWN menu_controls!!!");
            }
        }
        wait 0.05;
    }
}




//Menu Button Handling
_menuControls()
{
    if(self AttackButtonPressed()||self AdsButtonPressed())
    {
        if(self getMenuVar("menu_sounds"))
        {
            self playLocalSound("mouse_over");
        }
        scroll_value     = self getMenuScroller();
        old_scroll_value = scroll_value;
        scroll_value -= self AdsButtonPressed();
        scroll_value += self AttackButtonPressed();
        self setMenuScroller(scroll_value);
        self thread doScrollbarArrowColors(old_scroll_value,self getMenuScroller());
        self _scrollMenu();
        wait 0.170;
    }
    if(self UseButtonPressed())
    {
        if(self getMenuVar("menu_sounds"))
        {
            self playLocalSound("mouse_click");
        }
        if(!self.Menu[self getCurrentMenu()].menuLoader[self getMenuScroller()])
        {
            if(self hasMinVerifycationLevel(self getMenuScroller(),true))
            {
                func   = self.Menu[self getCurrentMenu()].func[self getMenuScroller()];
                input1 = self.Menu[self getCurrentMenu()].input1[self getMenuScroller()];
                input2 = self.Menu[self getCurrentMenu()].input2[self getMenuScroller()];
                input3 = self.Menu[self getCurrentMenu()].input3[self getMenuScroller()];
                self thread [[func]](input1,input2,input3);
                if(isDefined(self.Menu[self getCurrentMenu()].toggle[self getMenuScroller()]))
                {
                    self _scrollMenu("text_update");
                }
                if(self getCurrentMenu()=="ays_base" && self getCurrentMenuType()=="menu_ays" && self.Menu[self getCurrentMenu()].text[self getMenuScroller()]=="YES")
                {
                    wait 0.05;
                    self _loadMenu(self getMenuVar("AYS_parent"));
                }
            }
        }
        else
        {
            if(self hasMinVerifycationLevel(self getMenuScroller(),true))
            {
                if(isDefined(self.Menu[self getCurrentMenu()].ays_info[self getMenuScroller()]))
                {
                    self start_menu_AYS(self getCurrentMenu(),self.Menu[self getCurrentMenu()].ays_info[self getMenuScroller()],self.Menu[self getCurrentMenu()].func[self getMenuScroller()],self.Menu[self getCurrentMenu()].input1[self getMenuScroller()],self.Menu[self getCurrentMenu()].input2[self getMenuScroller()],self.Menu[self getCurrentMenu()].input3[self getMenuScroller()]);
                }
                else
                {
                    self _loadMenu(self.Menu[self getCurrentMenu()].input1[self getMenuScroller()]);
                }
            }
        }
        wait .4;
    }
    if(self MeleeButtonPressed())
    {
        if(self getMenuVar("menu_sounds"))
        {
            self playLocalSound("mouse_click");
        }
        if(self.Menu[self getCurrentMenu()].parent=="Exit")
        {
            self _closeMenu();
        }
        else
        {
            self _loadMenu(self.Menu[self getCurrentMenu()].parent);
        }
        wait .4;
    }
}




//open,close & restart menu
_openMenu()
{
    if(self getMenuVar("opened"))
    {
        self iprintln("^1Menu Already Opened!");
        return;
    }
    self notify("remove_access_msg");//skip menu access msg wait time
    if(self getCurrentMenuType()=="menu_ws")
    {
        self setCurrentMenu("ws_main_menu");
    }
    self setMenuVar("opened",true);
    self thread createBackgroundFog();
    self createMainGui();
    self _loadMenu(self getCurrentMenu());
    self thread onMenuNeedsStringFix();
}
_closeMenu()
{
    if(!self getMenuVar("opened"))
    {
        self iprintln("^1Menu Already Closed!");
        return;
    }
    self setMenuVar("ws_destroy_hud_on_menu_load",true);
    self destroyMenuTypeElems(true);
    self destroyMenuText(true);
    self destroyMainGui(true);
    self destroyBackgroundFog();
    self setMenuVar("opened",false);
    self freezeControls(false);
}
_restartMenu(error_msg="")
{
    self iprintln(error_msg);
    self iprintln("^2RESTARTING MENU...");
    self _closeMenu();
    wait 0.05;
    self setMenuVar("menu_controls","menu");
    self setMenuVar("menu_autoScrollTime",undefined);
    self setMenuVar("locked",false);
    self.PIX["CurrentMenu"] = undefined;
    wait .2;
    self _openMenu();
}






//load menu
_loadMenu(menu="main")
{
    if(menu=="ws_main_menu")
    {
        self setMenuVar("ws_confirmed_weapon","none");
        self setMenuVar("ws_confirmed_attachment","none");
        self setMenuVar("ws_confirmed_camo","none");
        self setMenuVar("ws_destroy_hud_on_menu_load",true);
    }
    self destroyMenuTypeElems();
    self destroyMenuText();
    self setCurrentMenu(menu);
    if(menu=="ws_attachment_menu"||menu=="ws_camo_menu")
    {
        self setMenuScroller(0,true);
    }
    self loadMenuStruct();
    if(self getCurrentMenuType()=="menu_ays")
    {
        self fadeVerticalScrollbar(.4,0);
        self switchSelectbarShader("popup_button_selection_bar",230,20,getMenuPosForAlign(self getMenuVar("menu_main_pos")).x);
    }
    else
    {
        self fadeVerticalScrollbar(.4,1);
        self switchSelectbarShader("menu_setting_selection_bar",220,20,getMenuPosForAlign(self getMenuVar("menu_main_pos")).x-5);
    }
    self updateMenuExtraSpace();
    self thread updateMenuTitleString();
    self thread _scrollMenu("selectbar_only",.3);
    self updateBackgroundSize();
    self createMenuTypeElems();
    self createMenuText();
    self _scrollMenu();
    wait 0.05;
}




//scrolling
_scrollMenu(type="full_scroll",move_time=0.170)
{
    if(isDefined(self getMenuVar("menu_autoScrollTime")))
    {
        move_time = self getMenuVar("menu_autoScrollTime");
    }
    
    
    if(type=="text_update")
    {
        self loadMenuStruct();
    }
    
    //type = full_scroll,text_update,selectbar_only
    if(!isDefined(self.Menu[self getCurrentMenu()].text[self getMenuScroller()-UNLM_SCROLL_MAX_HALF])||(self getMenuSize()<=UNLM_SCROLL_MAX))
    {
        if(type=="full_scroll"||type=="text_update")
        {
            for(i=0;i<UNLM_SCROLL_MAX;i++)
            {
                self.Hud["Text"][i] _setText(isDefined(self.Menu[self getCurrentMenu()].text[i]) ? self.Menu[self getCurrentMenu()].text[i] : "");
                self.Hud["Text"][i] doMenuTextToggleColor((isDefined(self.Menu[self getCurrentMenu()].toggle[i])) ? true : false,(self.Menu[self getCurrentMenu()].toggle[i]==true) ? true : false);
                self.Hud["Text"][i] doMenuTextSelectedBlink((i==self getMenuScroller()) ? true : false,i,self);
            }
        }
        if(type!="text_update")
        {
            self.Hud["Select_Bar"] elemMoveOverTimeY(move_time,((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 24) + (18*self getMenuScroller()));
        }
    }
    else
    {
        if(isDefined(self.Menu[self getCurrentMenu()].text[self getMenuScroller()+UNLM_SCROLL_MAX_HALF]))
        {
            if(type=="full_scroll"||type=="text_update")
            {
                PIX = 0;
                for(i=self getMenuScroller()-UNLM_SCROLL_MAX_HALF;i<self getMenuScroller()+UNLM_SCROLL_MAX_HALF_ONE;i++)
                {
                    self.Hud["Text"][PIX] _setText(isDefined(self.Menu[self getCurrentMenu()].text[i]) ? self.Menu[self getCurrentMenu()].text[i] : "");
                    self.Hud["Text"][PIX] doMenuTextToggleColor((isDefined(self.Menu[self getCurrentMenu()].toggle[i])) ? true : false,(self.Menu[self getCurrentMenu()].toggle[i]==true) ? true : false);
                    self.Hud["Text"][PIX] doMenuTextSelectedBlink((i==self getMenuScroller()) ? true : false,i,self);
                    PIX ++;
                }
            }
            if(type!="text_update")
            {
                self.Hud["Select_Bar"] elemMoveOverTimeY(move_time,((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 24) + (18*UNLM_SCROLL_MAX_HALF));
            }
        }
        else
        {
            if(type=="full_scroll"||type=="text_update")
            {
                for(i=0;i<UNLM_SCROLL_MAX;i++)
                {
                    self.Hud["Text"][i] _setText(self.Menu[self getCurrentMenu()].text[self getMenuSize()+(i-UNLM_SCROLL_MAX)]);
                    self.Hud["Text"][i] doMenuTextToggleColor((isDefined(self.Menu[self getCurrentMenu()].toggle[self getMenuSize()+(i-UNLM_SCROLL_MAX)])) ? true : false,(self.Menu[self getCurrentMenu()].toggle[self getMenuSize()+(i-UNLM_SCROLL_MAX)]==true) ? true : false);
                    self.Hud["Text"][i] doMenuTextSelectedBlink((self getMenuSize()+(i-UNLM_SCROLL_MAX)==self getMenuScroller()) ? true : false,self getMenuSize()+(i-UNLM_SCROLL_MAX),self);
                }
            }
            if(type!="text_update")
            {
                self.Hud["Select_Bar"] elemMoveOverTimeY(move_time,((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 24)+(18*((self getMenuScroller()-self getMenuSize())+UNLM_SCROLL_MAX)));
            }
        }
    }
    if(type!="text_update")
    {
        self updateScrollBar_Pos();
        if(self.Hud["Select_Bar"].alpha!=1)
        {
           self.Hud["Select_Bar"] elemFadeOverTime(.2,1);
        }
    }
    if(type=="full_scroll"||type=="text_update")
    {
        self scrollMenuTypeElems();
    }
}

doMenuTextSelectedBlink(start_stop_bool,index,client)
{
    if(start_stop_bool)
    {
        if(client hasMinVerifycationLevel(index,false))
        {
            self thread elemBlink();
        }
        else
        {
            self notify("Update_Blink");
            self.alpha = 0.5;
        }
    }
    else
    {
        self notify("Update_Blink");
        self.alpha = (client hasMinVerifycationLevel(index,false)) ? 1 : 0.5;
    }
}
doMenuTextToggleColor(def,bool)
{
    if(def)
    {
        if(bool)
        {
            self.glowColor = (0.1,0.7,0.3);
        }
        else
        {
            self.glowColor = (0.8,0,0);
        }
        self.glowAlpha = 1;
    }
    else
    {
        self.glowAlpha = 0;
    }
}


//Auto Scrolling
_autoScrollTo(pos,time = 0.170)
{
    self setMenuVar("menu_autoScrollTime",time);
    
    //Check if pos = string
    //if it is a string check for top,center or bottom
    if(isString(pos))
    {
        if(pos == "top")
        {
            pos = 0;
        }
        else if(pos == "center")
        {
            pos = int((self getMenuSize()-1)/2);
        }
        else
        {
            pos = self getMenuSize()-1;
        }
    }
    
    //Maybe add a pos exists check here???
    
    //Get Direction
    if(pos < self getMenuScroller())
    {
        direction = -1;
    }
    else if(pos > self getMenuScroller())
    {
        direction = 1;
    }
    else
    {
        self setMenuVar("menu_autoScrollTime",undefined);
        return;//no direction
    }
    
    self setMenuVar("locked",true);//lock controls while auto scrolling
    current_scroller = self getMenuScroller();
    old_scroll_value = current_scroller;
    while(current_scroller != pos)//scroll until pos is reached
    {
        current_scroller = current_scroller + (1*direction);
        self setMenuScroller(current_scroller);
        self thread doScrollbarArrowColors(old_scroll_value,self getMenuScroller());
        self _scrollMenu();
        wait self getMenuVar("menu_autoScrollTime");
    }
    
    self setMenuVar("menu_autoScrollTime",undefined);//set auto scroll time to undefined
    self setMenuVar("locked",false);//unlock controls
}



onMenuNeedsStringFix()
{
    while(self getMenuVar("opened"))
    {
        level waittill("overflow_fixed");
        self _scrollMenu("text_update");
    }
}