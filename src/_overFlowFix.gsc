init_overFlowFix()
{
    level.overFlowFix_Started = true;
    level.strings = [];
    
    level.overflowElem = createServerFontString("default",1.5);
    level.overflowElem setText("overflow");   
    level.overflowElem.alpha = 0;
    
    level thread overflowfix_monitor();
}
fix_string()
{
    self notify("new_string");
    self endon("new_string");
    while(isDefined(self))
    {
        level waittill("overflow_fixed");
        if(isDefined(self.string) && self.overflow_autoFix)
        {
            self _setText(self.string);
        }
    }
}
addString(string)
{
    if(!stringInArray(level.strings,string))
    {
        level.strings[level.strings.size] = string;
        level notify("string_added");
    }
}
overflowfix_monitor()
{  
    level endon("game_ended");
    for(;;)
    {
        level waittill("string_added");
        if(level.strings.size >= 80)//80
        {
            level.overflowElem ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("overflow_fixed");
            //getHost() iprintln("^1OVERFLOW FIXED!");
        }
        wait 0.01; 
    }
}