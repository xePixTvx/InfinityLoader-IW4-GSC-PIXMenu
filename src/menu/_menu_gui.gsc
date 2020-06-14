//Main GUI
createMainGui()
{   
    self.Hud["BG"] = createRectangle("TOP","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,getMenuPosForAlign(self getMenuVar("menu_main_pos")).y,230,45,(0.5,0.5,0.5),1,"white");//base height 45
    self.Hud["BG"] elemSetSort(1);
    
    self.Hud["Title_Text"] = createText("hudBig",1.0,"CENTER","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,0,(1,1,1),1,(0,0,0),0,"");//self.Menu[self getCurrentMenu()].title
    self.Hud["Title_Text"].y = ((self.Hud["BG"].y + 5) + (self.Hud["Title_Text"].height/2));
    self.Hud["Title_Text"] elemSetSort(7);
    
    self.Hud["Select_Bar"] = createRectangle("CENTER","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x-5,0,220,20,(0,0,0),1,"menu_setting_selection_bar");//menu_setting_selection_bar
    self.Hud["Select_Bar"].currentShader = "menu_setting_selection_bar";
    self.Hud["Select_Bar"].y = ((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 24);
    self.Hud["Select_Bar"] elemSetSort(7);
    
    self.Hud["Scrollbar_Arrow_Top"] = createRectangle("TOP","TOP",self.Hud["BG"].x + 110,0,8,8,(1,1,1),1,"ui_scrollbar_arrow_up_a");
    self.Hud["Scrollbar_Arrow_Top"].y = self.Hud["BG"].y;
    self.Hud["Scrollbar_Arrow_Top"] elemSetSort(8);
    
    self.Hud["Scrollbar_Bg"] = createRectangle("TOP","TOP",self.Hud["BG"].x + 110,self.Hud["BG"].y + 10,8,27,(0.3,0.3,0.3),1,"white");
    self.Hud["Scrollbar_Bg"] elemSetSort(8);
    
    self.Hud["Scrollbar_Arrow_Bottom"] = createRectangle("TOP","TOP",self.Hud["BG"].x + 110,0,8,8,(1,1,1),1,"ui_scrollbar_arrow_dwn_a");
    self.Hud["Scrollbar_Arrow_Bottom"].y = self.Hud["BG"].y + (self.Hud["BG"].height - self.Hud["Scrollbar_Arrow_Bottom"].height);
    self.Hud["Scrollbar_Arrow_Bottom"] elemSetSort(8);

    self.Hud["Scrollbar_Thumb"] = createRectangle("TOP","TOP",self.Hud["BG"].x + 110,self.Hud["BG"].y + 10,8,2,(0.8,0.8,0.8),1,"white");
    self.Hud["Scrollbar_Thumb"] elemSetSort(9);
    
    self.Hud["Corner_Glow"] = createRectangle("TOP","TOP",self.Hud["BG"].x+35,0,300,120,(1,1,1),0,"mockup_bg_glow");
    self.Hud["Corner_Glow"].y = ((getMenuPosForAlign(self getMenuVar("menu_main_pos")).y + (self.Hud["BG"].height)) - (self.Hud["Corner_Glow"].height)) + 0.5;
    self.Hud["Corner_Glow"] elemSetSort(6);
    if(self getMenuVar("colorful_glow"))
    {
        self.Hud["Corner_Glow"] thread elemSmoothFlash();
    }
    self.Hud["Corner_Glow"] thread elemGlow(2);
}
destroyMainGui(fade_out=false)
{
    time = .4;
    if(fade_out)
    {
        self.Hud["BG"] elemFadeOverTime(time,0);
        self.Hud["Title_Text"] elemFadeOverTime(time,0);
        self.Hud["Select_Bar"] elemFadeOverTime(time,0);
        self.Hud["Scrollbar_Arrow_Top"] elemFadeOverTime(time,0);
        self.Hud["Scrollbar_Bg"] elemFadeOverTime(time,0);
        self.Hud["Scrollbar_Arrow_Bottom"] elemFadeOverTime(time,0);
        self.Hud["Scrollbar_Thumb"] elemFadeOverTime(time,0);
        self.Hud["Corner_Glow"] notify("end_glow");
        self.Hud["Corner_Glow"] elemFadeOverTime(time,0);
        wait time;
    }
    self.Hud["BG"] destroy();
    self.Hud["Title_Text"] destroy();
    self.Hud["Select_Bar"] destroy();
    self.Hud["Scrollbar_Arrow_Top"] destroy();
    self.Hud["Scrollbar_Bg"] destroy();
    self.Hud["Scrollbar_Arrow_Bottom"] destroy();
    self.Hud["Scrollbar_Thumb"] destroy();
    self.Hud["Corner_Glow"] destroy();
}


//Hide & Show Vertical Scrollbar
fadeVerticalScrollbar(time,alpha)
{
    self.Hud["Scrollbar_Arrow_Top"] elemFadeOverTime(time,alpha);
    self.Hud["Scrollbar_Bg"] elemFadeOverTime(time,alpha);
    self.Hud["Scrollbar_Arrow_Bottom"] elemFadeOverTime(time,alpha);
    self.Hud["Scrollbar_Thumb"] elemFadeOverTime(time,alpha);
}


//Switch Selectbar Shader
switchSelectbarShader(shader,w,h,x)
{
    if(self.Hud["Select_Bar"].currentShader!=shader)
    {
        self.Hud["Select_Bar"] elemFadeOverTime(.2,0);
        wait .2;
        self.Hud["Select_Bar"] setShader(shader,w,h);
        self.Hud["Select_Bar"].currentShader = shader;
        self.Hud["Select_Bar"].x = x;
        //self.Hud["Select_Bar"] elemFadeOverTime(.2,1);
        //wait .2;
    }
}



//BG FOG
createBackgroundFog()
{
    self.Hud["Stencil_Base"] = createShaderBasic("fullscreen","fullscreen",0,0,640,480,"xpbar_stencilbase",(1,1,1),1);
    self.Hud["Stencil_Base"] elemSetSort(0);
    
    //OLD FULLSCREEN FOGS --- removed cause of movement problems
    /*self.Hud["Fog_Stencil_1"] = createShaderBasic("fullscreen","fullscreen",fog_1_x_start,0,1708,480,"mw2_popup_bg_fogstencil",(1,1,1),0.75);
    self.Hud["Fog_Stencil_1"] elemSetSort(2);
    
    self.Hud["Fog_Scroll_1"] = createShaderBasic("fullscreen","fullscreen",fog_1_x_start,0,1708,480,"mw2_popup_bg_fogscroll",(0.85,0.85,0.85),1);
    self.Hud["Fog_Scroll_1"] elemSetSort(4);
    
    self.Hud["Fog_Stencil_2"] = createShaderBasic("fullscreen","fullscreen",fog_2_x_start,0,1708,480,"mw2_popup_bg_fogstencil",(1,1,1),0.75);
    self.Hud["Fog_Stencil_2"] elemSetSort(3);
    
    self.Hud["Fog_Scroll_2"] = createShaderBasic("fullscreen","fullscreen",fog_2_x_start,0,1708,480,"mw2_popup_bg_fogscroll",(0.85,0.85,0.85),1);
    self.Hud["Fog_Scroll_2"] elemSetSort(5);
    */
    
    start_position            = [(getMenuPosForAlign(self getMenuVar("menu_main_pos")).x + 140),(getMenuPosForAlign(self getMenuVar("menu_main_pos")).x - 140)];
    start_position_directions = ["left","right"];
    fog_1_index               = randomInt(start_position.size);
    fog_2_index               = (fog_1_index!=0) ? 0 : 1;
    
    self.Hud["Fog_Scroll_1"] = createRectangle("CENTER","CENTER",0,0,1708,480,(0.85,0.85,0.85),1,"mw2_popup_bg_fogscroll");
    self.Hud["Fog_Scroll_1"].min_x = getMenuPosForAlign(self getMenuVar("menu_main_pos")).x - 140;
    self.Hud["Fog_Scroll_1"].max_x = getMenuPosForAlign(self getMenuVar("menu_main_pos")).x + 140;
    self.Hud["Fog_Scroll_1"].move_direction = start_position_directions[fog_1_index];
    self.Hud["Fog_Scroll_1"].x = start_position[fog_1_index];
    self.Hud["Fog_Scroll_1"] elemSetSort(4);
    
    self.Hud["Fog_Stencil_1"] = createRectangle("CENTER","CENTER",self.Hud["Fog_Scroll_1"].x,self.Hud["Fog_Scroll_1"].y,self.Hud["Fog_Scroll_1"].width,self.Hud["Fog_Scroll_1"].height,(1,1,1),0.75,"mw2_popup_bg_fogstencil");
    self.Hud["Fog_Stencil_1"] elemSetSort(2);
    
    self.Hud["Fog_Scroll_2"] = createRectangle("CENTER","CENTER",0,0,1708,480,(0.85,0.85,0.85),1,"mw2_popup_bg_fogscroll");
    self.Hud["Fog_Scroll_2"].min_x = getMenuPosForAlign(self getMenuVar("menu_main_pos")).x - 140;
    self.Hud["Fog_Scroll_2"].max_x = getMenuPosForAlign(self getMenuVar("menu_main_pos")).x + 140;
    self.Hud["Fog_Scroll_2"].move_direction = start_position_directions[fog_2_index];
    self.Hud["Fog_Scroll_2"].x = start_position[fog_2_index];
    self.Hud["Fog_Scroll_2"] elemSetSort(5);
    
    self.Hud["Fog_Stencil_2"] = createRectangle("CENTER","CENTER",self.Hud["Fog_Scroll_2"].x,self.Hud["Fog_Scroll_2"].y,self.Hud["Fog_Scroll_2"].width,self.Hud["Fog_Scroll_1"].height,(1,1,1),0.75,"mw2_popup_bg_fogstencil");
    self.Hud["Fog_Stencil_2"] elemSetSort(3);

    
    self.Hud["Fog_Scroll_1"] thread doFogAnimation(self.Hud["Fog_Stencil_1"]);
    wait .2;
    self.Hud["Fog_Scroll_2"] thread doFogAnimation(self.Hud["Fog_Stencil_2"]);
    
    if(self getMenuVar("colorful_fog"))
    {
        self.Hud["Fog_Scroll_1"] thread elemSmoothFlash();
        self.Hud["Fog_Stencil_1"] thread elemSmoothFlash();
        self.Hud["Fog_Scroll_2"] thread elemSmoothFlash();
        self.Hud["Fog_Stencil_2"] thread elemSmoothFlash();
    }
}
destroyBackgroundFog()
{
    self.Hud["Stencil_Base"] destroy();
    self.Hud["Fog_Stencil_1"] destroy();
    self.Hud["Fog_Scroll_1"] destroy();
    self.Hud["Fog_Stencil_2"] destroy();
    self.Hud["Fog_Scroll_2"] destroy();
}
doFogAnimation(fog_stencil)
{
    while(isDefined(self))
    {
        pos = (self.move_direction=="left") ? self.min_x : self.max_x;
        self elemMoveOverTimeX(BG_FOG_SPEED,pos);
        fog_stencil elemMoveOverTimeX(BG_FOG_SPEED,pos);
        wait BG_FOG_SPEED;
        if(self.x <= self.min_x)
        {
            self.move_direction = "right";
        }
        if(self.x >= self.max_x)
        {
            self.move_direction = "left";
        }
    }
}



//Update Current Menu Extra Space Var
updateMenuExtraSpace()
{
    if(self getMenuVar("menu_extra_space") != self getCurrentMenuExtraSpace())
    {
        self setMenuVar("menu_extra_space",self getCurrentMenuExtraSpace());
    }
}


//Update BG Size
updateBackgroundSize()
{
    height = (self getMenuSize()<=UNLM_SCROLL_MAX) ? 45 + (((self getMenuSize()-1)*18) + self getMenuVar("menu_extra_space")) : 45 + (((UNLM_SCROLL_MAX-1)*18) + self getMenuVar("menu_extra_space"));
    self.Hud["BG"] elemScaleOverTime(.3,230,height);
    self.Hud["Scrollbar_Bg"] elemScaleOverTime(.3,8,height-20);
    self.Hud["Scrollbar_Arrow_Bottom"] elemMoveOverTimeY(.3,self.Hud["BG"].y + (height - self.Hud["Scrollbar_Arrow_Bottom"].height));
    self.Hud["Corner_Glow"] elemMoveOverTimeY(.3,((getMenuPosForAlign(self getMenuVar("menu_main_pos")).y + (self.Hud["BG"].height)) - (self.Hud["Corner_Glow"].height)) + 0.5);
    
    //VERTICAL SCROLLBAR
    self setMenuVar("menu_scrollbar_MAX_HEIGHT",height-20);
    thumb_size = (self getMenuVar("menu_scrollbar_MAX_HEIGHT") - ((self getMenuSize()-1)*5)) < 2 ? 2 : ((self getMenuVar("menu_scrollbar_MAX_HEIGHT") - ((self getMenuSize()-1)*5)) > self getMenuVar("menu_scrollbar_MAX_HEIGHT") ? self getMenuVar("menu_scrollbar_MAX_HEIGHT") : (self getMenuVar("menu_scrollbar_MAX_HEIGHT") - ((self getMenuSize()-1)*5)));
    self setMenuVar("menu_scrollbar_CURRENT_MAX_TOP_POS",self.Hud["BG"].y + 10);
    self setMenuVar("menu_scrollbar_CURRENT_THUMB_SIZE",thumb_size);
    self.Hud["Scrollbar_Thumb"] elemScaleOverTime(.3,8,thumb_size);
    self updateScrollBar_Pos(.3);
    wait .3;
}



//Update Scrollbar(Vertical) Position
updateScrollBar_Pos(move_time)
{
    time     = (isDefined(move_time)) ? move_time : ((!isDefined(self getMenuVar("menu_autoScrollTime"))) ? 0.170 : self getMenuVar("menu_autoScrollTime"));
    max_top  = self getMenuVar("menu_scrollbar_CURRENT_MAX_TOP_POS");
    scroller = self getMenuScroller();
    size     = (self getMenuSize()-1)/(self getMenuVar("menu_scrollbar_MAX_HEIGHT")-self getMenuVar("menu_scrollbar_CURRENT_THUMB_SIZE"));
    self.Hud["Scrollbar_Thumb"] elemMoveOverTimeY(time,max_top + (scroller/size));
}



//Update Scrollbar(Vertical) Arrow Colors while scrolling
doScrollbarArrowColors(old_scroller,new_scroller)
{
    time = (!isDefined(self getMenuVar("menu_autoScrollTime"))) ? 0.170 : self getMenuVar("menu_autoScrollTime");
    self notify("update_scrollbar_arrow_colors");
    self endon("update_scrollbar_arrow_colors");
    elems = [self.Hud["Scrollbar_Arrow_Bottom"],self.Hud["Scrollbar_Arrow_Top"]];
    elems[0].color = ((old_scroller < new_scroller) ? true : false) ? (1,0,0) : (1,1,1);
    elems[1].color = ((old_scroller < new_scroller) ? true : false) ? (1,1,1) : (1,0,0);
    wait time + 0.05;
    foreach(elem in elems)
    {
        if(isDefined(elem) && elem.color!=(1,1,1))
        {
            elem.color = (1,1,1);
        }
    }
}



//Create & Destroy Menu Text
createMenuText()
{
    self.Hud["Text"] = [];
    for(i=0;i<UNLM_SCROLL_MAX;i++)
    {
        if(self getCurrentMenuType()=="menu_ays")
        {
            self.Hud["Text"][i] = createText("hudBig",0.8,"CENTER","TOP",self.Hud["BG"].x,((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 23) + (18 * i),(1,1,1),1,(0,0,0),0,"");
            self.Hud["Text"][i].overflow_autoFix = false;
        }
        else
        {
            self.Hud["Text"][i] = createText("default",1.4,"LEFT","TOP",self.Hud["BG"].x-110,((self.Hud["Title_Text"].y + self getMenuVar("menu_extra_space")) + 23) + (18 * i),(1,1,1),1,(0,0,0),0,"");
            self.Hud["Text"][i].overflow_autoFix = false;
        }
        self.Hud["Text"][i] elemSetSort(10);
    }
}
destroyMenuText(fade_out=false)
{
    if(isDefined(self.Hud["Text"]))
    {
        text_elem_array = getArrayKeys(self.Hud["Text"]);
        if(fade_out)
        {
            for(i=text_elem_array.size;i>-1;i--)
            {
                self.Hud["Text"][text_elem_array[i]] destroy();
                wait 0.05;
            }
        }
        else
        {
            for(i=0;i<text_elem_array.size;i++)
            {
                self.Hud["Text"][text_elem_array[i]] destroy();
            }
        }
    }
}



//Update Menu Title Text
updateMenuTitleString(new_string=self.Menu[self getCurrentMenu()].title)
{
    self.Hud["Title_Text"] elemFadeOverTime(.2,0);
    wait .2;
    self.Hud["Title_Text"] _setText(new_string);
    self.Hud["Title_Text"] elemFadeOverTime(.2,1);
    wait .2;
}



//Menu Type Specific Stuff
createMenuTypeElems()
{
    if(self getCurrentMenuType()=="pic")
    {
        self createPicMenuElems();
    }
    if(self getCurrentMenuType()=="menu_ays")
    {
        self createAysInfo();
    }
    if(self getCurrentMenuType()=="menu_ws")
    {
        self createWeaponSelectorElems();
    }
}
destroyMenuTypeElems(fade_out=false)
{
    self destroyPicMenuElems(fade_out);
    self destroyAysInfo(fade_out);
    self destroyWeaponSelectorElems(fade_out);
}
scrollMenuTypeElems()
{
    if(self getCurrentMenuType()=="pic")
    {
        self thread scrollPicMenuElems();
    }
    if(self getCurrentMenuType()=="menu_ws")
    {
        self thread scrollWeaponSelectorElems();
    }
}



//Menu Type: pic
createPicMenuElems()
{
    if(!isDefined(self.Hud["menu_pic"]))
    {
        self.Hud["menu_pic"] = createRectangle("TOP","TOP",self.Menu[self getCurrentMenu()].pos_x,self.Menu[self getCurrentMenu()].pos_y,self.Menu[self getCurrentMenu()].pic_width,self.Menu[self getCurrentMenu()].pic_height,(1,1,1),0,self.Menu[self getCurrentMenu()].picture[self getMenuScroller()]);
        self.Hud["menu_pic"] elemSetSort(10);
    }
}
destroyPicMenuElems(fade_out=false)
{
    if(isDefined(self.Hud["menu_pic"]))
    {
        if(fade_out)
        {
            self.Hud["menu_pic"] elemFadeOverTime(.4,0);
            wait .4;
        }
        self.Hud["menu_pic"] destroy();
    }
}
scrollPicMenuElems()
{
    time = (!isDefined(self getMenuVar("menu_autoScrollTime"))) ? 0.170 : self getMenuVar("menu_autoScrollTime");
    self.Hud["menu_pic"] elemFadeOverTime(time,0);
    wait time;
    self.Hud["menu_pic"] setShader(self.Menu[self getCurrentMenu()].picture[self getMenuScroller()],self.Menu[self getCurrentMenu()].pic_width,self.Menu[self getCurrentMenu()].pic_height);
    self.Hud["menu_pic"] elemFadeOverTime(time,1);
}



//Menu Type: menu_ays
start_menu_AYS(parentMenu,info_text,func,inp1,inp2,inp3)
{
    self setMenuVar("AYS_parent",parentMenu);
    self setMenuVar("AYS_func",func);
    self setMenuVar("AYS_inp1",inp1);
    self setMenuVar("AYS_inp2",inp2);
    self setMenuVar("AYS_inp3",inp3);
    self setMenuVar("AYS_info",info_text);
    self _loadMenu("ays_base");
}

createAysInfo()
{
    if(isDefined(self getMenuVar("AYS_info")) && (self getMenuVar("AYS_info")!=""))
    {
        self.Hud["AYS_Info_Text"] = [];
        info = strTok(self getMenuVar("AYS_info"),";");
        for(i=0;i<info.size;i++)
        {
            if(!isDefined(self.Hud["AYS_Info_Text"][i]))
            {
                self.Hud["AYS_Info_Text"][i] = createText("default",1.5,"CENTER","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,(self.Hud["Title_Text"].y+20)+(18*i),(1,1,1),1,(0,0,0),0,info[i]);
                self.Hud["AYS_Info_Text"][i] elemSetSort(10);
            }
        }
    }
}
destroyAysInfo(fade_out=false)
{
    if(fade_out)
    {
        foreach(text in self.Hud["AYS_Info_Text"])
        {
            if(isDefined(text))
            {
                text elemFadeOverTime(.4,0);
            }
        }
        wait .4;
    }
    foreach(text in self.Hud["AYS_Info_Text"])
    {
        if(isDefined(text))
        {
            text destroy();
        }
    }
}


//Menu Type: menu_ays
createWeaponSelectorElems()
{
    if(self getMenuVar("ws_destroy_hud_on_menu_load"))
    {
        if(!isDefined(self.Hud["menu_ws_bg"]))
        {
            self.Hud["menu_ws_bg"] = createRectangle("TOP","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x-4,self.Hud["Title_Text"].y+9,218,64,(0.5,0.5,0.5),(1/1.75),"white");
            self.Hud["menu_ws_bg"] elemSetSort(10);
        }
        if(!isDefined(self.Hud["menu_ws_weapon_pic"]))
        {
            self.Hud["menu_ws_weapon_pic"] = createRectangle("TOP","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x,self.Hud["Title_Text"].y+8,180,70,(1,1,1),0,"");
            self.Hud["menu_ws_weapon_pic"] elemSetSort(11);
        }
        if(!isDefined(self.Hud["menu_ws_weapon_attach_pic"]))
        {
            self.Hud["menu_ws_weapon_attach_pic"] = createRectangle("TOP","TOP",getMenuPosForAlign(self getMenuVar("menu_main_pos")).x-90,self.Hud["Title_Text"].y+42,30,30,(1,1,1),0,"");
            self.Hud["menu_ws_weapon_attach_pic"] elemSetSort(11);
        }
    }
}
destroyWeaponSelectorElems(fade_out=false)
{
    if(self getMenuVar("ws_destroy_hud_on_menu_load"))
    {
        if(isDefined(self.Hud["menu_ws_bg"]))
        {
            if(fade_out)
            {
                self.Hud["menu_ws_bg"] elemFadeOverTime(.4,0);
                wait .4;
            }
            self.Hud["menu_ws_bg"] destroy();
        }
        if(isDefined(self.Hud["menu_ws_weapon_pic"]))
        {
            if(fade_out)
            {
                self.Hud["menu_ws_weapon_pic"] elemFadeOverTime(.4,0);
                wait .4;
            }
            self.Hud["menu_ws_weapon_pic"] destroy();
        }
        if(isDefined(self.Hud["menu_ws_weapon_attach_pic"]))
        {
            if(fade_out)
            {
                self.Hud["menu_ws_weapon_attach_pic"] elemFadeOverTime(.4,0);
                wait .4;
            }
            self.Hud["menu_ws_weapon_attach_pic"] destroy();
        }
    }
}
scrollWeaponSelectorElems()
{
    time = (!isDefined(self getMenuVar("menu_autoScrollTime"))) ? 0.170 : self getMenuVar("menu_autoScrollTime");
    if(self getCurrentMenu()=="ws_attachment_menu")
    {
        if(isDefined(self.Hud["menu_ws_weapon_attach_pic"]))
        {
            self.Hud["menu_ws_weapon_attach_pic"] elemFadeOverTime(time,0);
            wait time;
            self.Hud["menu_ws_weapon_attach_pic"] setShader(getAttachmentShader(self.Menu[self getCurrentMenu()].input1[self getMenuScroller()]),30,30);
            self.Hud["menu_ws_weapon_attach_pic"] elemFadeOverTime(time,1);
        }
    }
    else if(self getCurrentMenu()=="ws_camo_menu")
    {
        if(isDefined(self.Hud["menu_ws_bg"]))
        {
            self.Hud["menu_ws_bg"] elemFadeOverTime(time,0);
            wait 0.170;
            if(self.Menu[self getCurrentMenu()].input1[self getMenuScroller()]=="none")
            {
                bg_alpha = (1/1.75);
                shader   = "white";
                self.Hud["menu_ws_bg"].color = (0.5,0.5,0.5);
            }
            else
            {
                bg_alpha = 1;
                shader   = getCamoShader(self.Menu[self getCurrentMenu()].input1[self getMenuScroller()]);
                self.Hud["menu_ws_bg"].color = (1,1,1);
            }
            self.Hud["menu_ws_bg"] setShader(shader,218,64);
            self.Hud["menu_ws_bg"] elemFadeOverTime(time,bg_alpha);
        }
    }
    else
    {
        if(isDefined(self.Hud["menu_ws_weapon_pic"]))
        {
            self.Hud["menu_ws_weapon_pic"] elemFadeOverTime(time,0);
            wait time;
            self.Hud["menu_ws_weapon_pic"] setShader(getWeaponShader(self.Menu[self getCurrentMenu()].input1[self getMenuScroller()]),180,70);
            self.Hud["menu_ws_weapon_pic"] elemFadeOverTime(time,1);
        }
    }
}