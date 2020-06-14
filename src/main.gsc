/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : iw4_P!X_menu
*    Author : P!X
*    Game : MW2
*    Description : Starts Multiplayer code execution!
*    Start Date : 29.03.2020 16:47:02
*    Last Worked On Date: 18.05.2020 01:03
*    Current Version : 0.5
*
*/

/*
    Credits:
                P!X                     --- Mod Developer(Menu System,Verifycation System and more......)
                AgreedBog381 & SyGnUs   --- Infinity Loader Developers
                ImJtagModz/Dr JTAG      --- prestige/rank changing RPC Stuff
                Extinct & Leaf          --- for always being helpful
*/


            
            
/*
    Known Bugs:
*/




/*     TODO:
            #add menu settings save stuff
            #add perk menu functions(set,clear,unset,has,get.....) --- DONE
            #add basic perk menu ---- DONE
            #add weapon selector ---- DONE
            #add value editor
            #add position editor
            #implement AYS directly into the menu base ---- DONE
            #fix AYS scrolling(TOP to BOTTOM & BOTTOM to TOP) ---- DONE
    
*/
#define MENU_VERSION = 0.5;
#define ERROR_SHADER = "P!X_ERROR";
#define MENU_DEVELOPER = "P!X";

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    
    //Overflow Fix
    level.overFlowFix_Started = false;//--- dont edit
    
    //Menu Developer Stuff
    level.pixMenuDeveloperMode = true;
    
    //ERROR Image/Shader
    precacheShader(ERROR_SHADER);
    
    //Menu Shaders
    //precacheShader("mw2_main_background");//used for fullscreen
    precacheShader("mockup_bg_glow");//corner glow
    precacheShader("popup_button_selection_bar");//AYS selectbar
    precacheShader("menu_setting_selection_bar");//default selectbar
    precacheShader("ui_scrollbar_arrow_up_a");//vertical scrollbar arrow UP
    precacheShader("ui_scrollbar_arrow_dwn_a");//vertical scrollbar arrow DOWN
    //precacheShader("ui_scrollbar_arrow_right");//not used atm
    //precacheShader("ui_scrollbar_arrow_left");//not used atm
    precacheShader("xpbar_stencilbase");//used for bg fog
    precacheShader("mw2_popup_bg_fogstencil");//used for bg fog
    precacheShader("mw2_popup_bg_fogscroll");//used for bg fog
    
    //Prestige Selection(the rest should be precached in maps\mp\gametypes\_rank.gsc --- same for rank shaders)
    precacheShader("rank_prestige11");
    
    //Player Animations --- used for stalking/following clone atm
    precacheMpAnim("pb_stand_alert");
    precacheMpAnim("pb_walk_forward_akimbo");
    precacheMpAnim("pb_run_fast");
    precacheMpAnim("pb_sprint_akimbo");
    
    //Ranks used in setRank_RPC function
    level.RPC_ranks = ["000000","F40100","A40600","100E00","381800","1C2500","BC3400","184700","305C00","047400","948E00","0CAD00","6CCF00","B4F500","E41F01","FC4D01","FC7F01","E4B501","B4EF01","6C2D02","0C6F02","94B402","04FE02","5C4B03","9C9C03","C4F103","D44A04","CCA704","AC0805","746D05","ECD605","144506","ECB706","742F07","ACAB07","942C08","2CB208","743C09","6CCB09","145F0A","6CF70A","74940B","2C360C","94DC0C","AC870D","74370E","ECEB0E","14A50F","EC6210","742511","D8ED11","18BC12","349013","2C6A14","004A15","B02F16","3C1B17","A40C18","F80319","18011A","04041B","E40C1C","901B1D","20301E","944A1F","D46A20","089121","08BD22","D4EE23","206426"];
    
    //Remove Kill Triggers
    level thread removeKillTriggers();
    
    
    level thread init_menu_weapons();//load menu weapon list stuff
    level thread init_menu_perks();//load menu perk list stuff
    level thread init_verifycation_system();//load verifycation system settings
    level init_server_bools();//set server bools
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread _setupMenu();//setup menu stuff
        player thread player_monitor_verifycation();//start verifycation monitor for player
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    self.isFirstSpawn = true;
    for(;;)
    {
        self waittill("spawned_player");
        
        //Start OverFlowFix
        if(!level.overFlowFix_Started && self isHost())
        {
            level thread init_overFlowFix();
        }
        
        //Update Player Bools & Functions
        self update_player_bools_after_spawn();
        
        //on first spawn
        if(self.isFirstSpawn)
        {
            self player_set_verifycation_on_first_spawn();//give verifycation level on first spawn
            self.isFirstSpawn = false;
        }
    }
}