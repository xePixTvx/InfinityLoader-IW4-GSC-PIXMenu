init_menu_weapons()
{
    //Create List with all base weapon ids
    level.pix_weaponList = [];
    for(i=0;i<=149;i++)
    {
        weaponId    = tableLookup("mp/statsTable.csv",0,i,4);
        weaponClass = tableLookup("mp/statsTable.csv",0,i,2);
        
        //if weaponId exists + is in a weapon class
        if((weaponId!="") && isSubStr(weaponClass,"weapon_"))
        {
            addMenuWeapon(weaponId);
            precacheShader(getWeaponShader(weaponId));
        }
    }
    
    //Create Attachment List
    level.pix_attachmentList = [];
    for(i=1;i<=17;i++)
    {
        attachmentId = tableLookup("mp/attachmentTable.csv",0,i,4);
        addMenuAttachment(attachmentId);
        precacheShader(getAttachmentShader(attachmentId));
    }
    
    //Create Camo List
    level.pix_camoList = [];
    for(i=0;i<=8;i++)
    {
        camoId = tableLookup("mp/camoTable.csv",0,i,1);
        addMenuCamo(camoId);
        precacheShader(getCamoShader(camoId));
    }
}


addMenuWeapon(weaponId)
{
    i = level.pix_weaponList.size;
    level.pix_weaponList[i] = spawnStruct();
    level.pix_weaponList[i].id = weaponId;
}
addMenuAttachment(attachmentId)
{
    i = level.pix_attachmentList.size;
    level.pix_attachmentList[i] = spawnStruct();
    level.pix_attachmentList[i].id = attachmentId;
}
addMenuCamo(camoId)
{
    i = level.pix_camoList.size;
    level.pix_camoList[i] = spawnStruct();
    level.pix_camoList[i].id = camoId;
}