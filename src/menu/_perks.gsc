init_menu_perks()
{
    level.perk_tier = [];
    level.perk_tier[1] = ["specialty_marathon","specialty_fastreload","specialty_scavenger","specialty_bling","specialty_onemanarmy"];
    level.perk_tier[2] = ["specialty_bulletdamage","specialty_lightweight","specialty_hardline","specialty_coldblooded","specialty_explosivedamage"];
    level.perk_tier[3] = ["specialty_extendedmelee","specialty_bulletaccuracy","specialty_localjammer","specialty_heartbreaker","specialty_detectexplosive","specialty_pistoldeath"];
    for(number=1;number<=3;number++)
    {
        for(i=0;i<level.perk_tier[number].size;i++)
        {
            precacheShader(getPerkShader(level.perk_tier[number][i]));
            precacheShader(getPerkShader(getProPerkId(level.perk_tier[number][i])));
        }
    }
}
clearPerksCustom()
{
    self _clearPerks();
    self iprintln("^1Perks Cleared!");
    wait .2;
    self openMenu("perk_display");
    self thread maps\mp\gametypes\_playerlogic::hidePerksAfterTime(2.0);
    self thread maps\mp\gametypes\_playerlogic::hidePerksOnDeath();
}
clearPerkTier(tier_number)
{
    for(i=0;i<level.perk_tier[tier_number].size;i++)
    {
        if(self hasPerkCustom(level.perk_tier[tier_number][i]))
        {
            self _unsetPerk(level.perk_tier[tier_number][i]);
        }
        if(self hasPerkCustom(level.perk_tier[tier_number][i],"pro"))
        {
            self _unsetPerk(getProPerkId(level.perk_tier[tier_number][i]));
        }
    }
}
setPerkCustom(perk_id,type="default")
{
    tier_number = getPerkTierNumber(perk_id);
    if(isDefined(tier_number))
    {
        self clearPerkTier(tier_number);
    }
    if(type=="default")
    {
        if(self hasPerkCustom(perk_id))
        {
            if(self hasPerkCustom(perk_id,"pro"))
            {
                self _unsetPerk(getProPerkId(perk_id));
            }
            self _unsetPerk(perk_id);
        }
        else
        {
            self _setPerk(perk_id);
        }
    }
    else
    {
        if(self hasPerkCustom(perk_id,"pro"))
        {
            self _unsetPerk(perk_id);
            self _unsetPerk(getProPerkId(perk_id));
        }
        else
        {
            self _setPerk(perk_id);
            self _setPerk(getProPerkId(perk_id));
        }
    }
    wait 0.05;
    self openMenu("perk_display");
    self thread maps\mp\gametypes\_playerlogic::hidePerksAfterTime(2.0);
    self thread maps\mp\gametypes\_playerlogic::hidePerksOnDeath();
}
hasPerkCustom(perk_id,type="default")
{
    if(type=="default")
    {
        if(self _hasPerk(perk_id))
        {
            return true;
        }
    }
    else
    {
        if(self _hasPerk(perk_id) && self _hasPerk(getProPerkId(perk_id)))
        {
            return true;
        }
    }
    return false;
}
getPerkTierNumber(perk_id)
{
    for(number=1;number<=3;number++)
    {
        for(i=0;i<level.perk_tier[number].size;i++)
        {
            if(level.perk_tier[number][i]==perk_id)
            {
                return number;
            }
        }
    }
    return undefined;
}