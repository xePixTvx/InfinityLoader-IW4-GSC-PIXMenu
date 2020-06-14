//Create Text Elem for Client
createText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = self createFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort             = 0;
    textElem.type             = "text";
    textElem.color            = color;
    textElem.default_color    = color;
    textElem.alpha            = alpha;
    textElem.glowColor        = glowColor;
    textElem.glowAlpha        = glowAlpha;
    textElem.overflow_autoFix = true;
    if(isDefined(text))
    {
        textElem _setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

//Create Text Elem for Server
createServerText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = createServerFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort          = 0;
    textElem.type          = "text";
    textElem.color         = color;
    textElem.default_color = color;
    textElem.alpha         = alpha;
    textElem.glowColor     = glowColor;
    textElem.glowAlpha     = glowAlpha;
    textElem.overflow_autoFix = true;
    if(isDefined(text))
    {
        textElem _setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

_setText(string)
{
    self.string = string;
    self setText(string);
    self addString(string);
    self thread fix_string();
}
getText()
{
    if(isDefined(self.string))
    {
        return self.string;
    }
    return "UNKNOWN STRING";
}


//Create Shader/Texture Elem for Client
createRectangle(align,relative,x,y,width,height,color,alpha,shadero)
{
    rect_elem               = newClientHudElem(self);
    rect_elem.width         = width;
    rect_elem.height        = height;
    rect_elem.align         = align;
    rect_elem.relative      = relative;
    rect_elem.xOffset       = 0;
    rect_elem.yOffset       = 0;
    rect_elem.children      = [];
    rect_elem.color         = color;
    rect_elem.default_color = color;
    if(isDefined(alpha))
    {
        rect_elem.alpha = alpha;
    }
    else
    {
        rect_elem.alpha = 1;
    }
    rect_elem setShader(shadero,width,height);
    rect_elem.hidden = false;
    rect_elem.sort            = 0;
    rect_elem setPoint(align,relative,x,y);
    return rect_elem;
}

//Create Old Shool/Basic Shader for Client --- setPoint not used
createShaderBasic(h_aling,v_aling,x,y,width,height,shader,color,alpha)
{
    basic_elem           = newClientHudElem(self);
    basic_elem.x         = x;
    basic_elem.y         = y;
    basic_elem.horzAlign = h_aling;
    basic_elem.vertAlign = v_aling;
    basic_elem setShader(shader,width,height);
    basic_elem.color         = color;
    basic_elem.default_color = color;
    basic_elem.alpha         = alpha;
    return basic_elem;
}

//Change Elem stuff over time Functions
elemFadeOverTime(time,alpha)
{
    self fadeovertime(time);
    self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
    self moveovertime(time);
    self.y = y;
}
elemMoveOverTimeX(time,x)
{
    self moveovertime(time);
    self.x = x;
}
elemMoveOverTimeAll(time,pos)
{
    self moveovertime(time);
    self.x = pos;
    self.y = pos;
}
elemScaleOverTime(time,width,height)
{
    self scaleovertime(time,width,height);
    self.width  = width;
    self.height = height;
}
elemSetSort(val)
{
    self.sort = val;
}
elemGlow(time)
{
    self endon("end_glow");
    while(isDefined(self))
    {
        self fadeOverTime(time);
        self.alpha = randomFloatRange(0.3,1);
        wait time;
    }
}
elemBlink()
{
    self notify("Update_Blink");
    self endon("Update_Blink");
    while(isDefined(self))
    {
        self elemFadeOverTime(.3,1);
        wait .3;
        self elemFadeOverTime(.3,0.3);
        wait .3;
    }
}
elemSmoothFlash()//ghetto as fuck YAY xD
{
    elem     = self;
    r        = randomInt(255);
    r_bigger = true;
    g        = randomInt(255);
    g_bigger = false;
    b        = randomInt(255);
    b_bigger = true;
    self endon("end_smooth_flash");
    while(isDefined(elem))
    {
        if(r_bigger==true)
        {
            r+=randomIntRange(5,15);
            if(r>254)
            {
                r_bigger = false;
            }
        }
        else
        {
            r-=randomIntRange(5,15);
            if(r<2)
            {
                r_bigger = true;
            }
        }
        if(g_bigger==true)
        {
            g+=randomIntRange(5,15);
            if(g>254)
            {
                g_bigger = false;
            }
        }
        else
        {
            g-=randomIntRange(5,15);
            if(g<2)
            {
                g_bigger = true;
            }
        }
        if(b_bigger==true)
        {
            b+=randomIntRange(5,15);
            if(b>254)
            {
                b_bigger = false;
            }
        }
        else
        {
            b-=randomIntRange(5,15);
            if(b<2)
            {
                b_bigger = true;
            }
        }
        elem.color = ((r/255),(g/255),(b/255));
        wait 0.01;
    }
}


//New setPoint function(from COD5??)
setPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
}


//Test Functions
debugExit()
{
    exitLevel(false);
}
Test(input="^1Test")
{
    self iprintln(input);
}
TestToggle()
{
    if(!self.TestToggle)
    {
        self.TestToggle = true;
    }
    else
    {
        self.TestToggle = false;
    }
}
foreachKeyTest()
{
    foreach(number,player in level.players)
    {
        iprintln("^2Name: " + level.players[number].name);
        iprintln("^1Number: " + number);
    }
}
OverFlowTest(testFix = false)
{
    self.testText = createText("default",2.0,"CENTER","CENTER",0,0,0,(1,0,0),1,(0,0,0),0);
    i             = 0;
    for(;;)
    {
        if(!testFix)
        {
            self.testText setText("Strings: " + i);
        }
        else
        {
            self.testText _setText("Strings: " + i);
        }
        i++;
        wait 0.05;
    }
}
spawnTestClient()
{
    test_client = addtestclient();
    test_client.pers["isBot"] = true;
    wait .2;
    test_client notify("menuresponse",game["menu_team"],"autoassign");
    wait 0.5;
    test_client notify("menuresponse","changeclass","class"+randomInt(5));
    test_client waittill("spawned_player");
    iprintln("TEST: test_client ^1SPAWNED");
    //test_client thread OverFlowTest(true);
}

//Check if string is in array
stringInArray(ar,string)
{
    array = [];
    array = ar;
    for(i=0;i<array.size;i++)
    {
        if(array[i]==string)
        {
            return true;
        }
    }
    return false;      
}


intToBool(int)
{
    return (int==1) ? true : false;
}
boolToInt(bool)
{
    return (bool==true) ? 1 : 0;
}

//Get Player Cursor Position
getCursorPos(multiplier = 1000000)
{
    angle_forward      = AnglesToForward(self getPlayerAngles());
    multiplied_vector3 = angle_forward * multiplier;
    return BulletTrace(self getTagOrigin("tag_eye"),multiplied_vector3,0,self)["position"];
}

//Get Player Name without clantag
getTrueName(playerName = self.name)
{
    if(isSubStr(playerName,"]"))
    {
        name = strTok(playerName,"]");
        return name[name.size-1];
    }
    else
    {
        return playerName;
    }
}

//Get Host Player
getHost()
{
    foreach(player in level.players)
    {
        if(player isHost())
        {
            return player;
        }
    }
}

//Delete or Destroy Entity after some time
removeEntityOverTime(time,type = "delete")
{
    wait time;
    if(type == "delete")
    {
        self delete();
    }
    else
    {
        self destroy();
    }
}

//notify entity after some time
ent_notify_after_time_period(waitTime,notification,end)
{
    if(isDefined(end))
    {
        self endon(end);
    }
    self endon(notification);
    wait waitTime;
    self notify(notification);
}

//Delete Kill Triggers
removeKillTriggers()
{
    ents = getEntArray();
    for(index=0;index<ents.size;index++)
    {
        if(isSubStr(ents[index].classname,"trigger_hurt"))
        {
            ents[index].origin = (0,0,9999999);//move them up
            //ents[index] delete();//destroy them??
        }
    }
}

//Change Game Type
changeGameType(type,restart = false)
{
    setDvar("g_gametype",type);
    setDvar("ui_gametype",type);
    if(restart)
    {
        map_restart(false);
    }
}


//Platform Checks
isConsole()
{
    if(isXbox()||isPs3())
    {
        return true;
    }
    return false;
}
isXbox()
{
    if(level.xenon)
    {
        return true;
    }
    return false;
}
isPs3()
{
    if(level.ps3)
    {
        return true;
    }
    return false;
}


//Simple Client Funcs
killClient(client,attacker)
{
    if(!isDefined(attacker)||(client==attacker))
    {
        client suicide();
    }
    else
    {
        //add different hit/kill/attack positions????????
        client thread [[level.callbackPlayerDamage]](attacker,attacker,100,0,"MOD_HEAD_SHOT",attacker getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);
    }
}
kickClient(client)
{
    if(client isHost())
    {
        self iprintln("^1You can't kick the host player!!!");
        return;
    }
    kick(client getEntityNumber());
    self _loadMenu("players_menu");
}