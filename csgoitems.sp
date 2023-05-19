#include <sourcemod>
#include <sdktools>
#include <PTaH>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
    name = "Test",
    author = "Test",
    description = "Test",
    version = "1.0"
};

int knife_ids[] = {
    500,
    503,
    505,
    506,
    507,
    508,
    509,
    512,
    514,
    515,
    516,
    517,
    518,
    519,
    520,
    521,
    522,
    523,
    525
};

bool IsKnife(int id)
{
    for(int i = 0; i < sizeof(knife_ids); i++)
    {
        if(knife_ids[i] == id)
        {
            return true;
        }
    }

    return false;
}

Action WeaponCanUsePre(int client, int weapon, bool& pickup)
{
    int weapon_id = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
    if (IsKnife(weapon_id))
    {
        pickup = true;
        return Plugin_Changed;
        // PrintToConsoleAll("Client: %i\nWeapon: %i", client, weapon);
    }
    return Plugin_Continue;
}

Action GiveNamedItemPre(int client, char classname[64], CEconItemView &item, bool &ignoredCEconItemView, bool &OriginIsNULL, float Origin[3])
{
    if(StrContains(classname, "knife") > -1 || StrContains(classname, "bayonet") > -1)
    {
        ignoredCEconItemView = true;
        strcopy(classname, sizeof(classname), "weapon_knife_karambit");
        return Plugin_Changed;
    }
    return Plugin_Continue;
}

void GiveNamedItemPost(int client, const char[] classname, const CEconItemView item, int entity, bool OriginIsNULL, const float Origin[3])
{
    if(IsValidEntity(entity))
    {
        if(StrContains(classname, "knife") > -1 || StrContains(classname, "bayonet") > -1)
        {
            SetEntProp(entity, Prop_Send, "m_nFallbackPaintKit", 572);
            SetEntProp(entity, Prop_Send, "m_iItemIDHigh", -1);
            SetEntProp(entity, Prop_Send, "m_iEntityQuality", 3);
            SetEntProp(entity, Prop_Send, "m_iAccountID", GetSteamAccountID(client));
            SetEntProp(entity, Prop_Send, "m_iItemIDLow", -1);
            SetEntProp(entity, Prop_Send, "m_hOwnerEntity", client);
            SetEntProp(entity, Prop_Send, "m_hPrevOwner", -1);
        }
    }
}

public void OnPluginStart()
{
    PTaH(PTaH_WeaponCanUsePre, Hook, WeaponCanUsePre);
    PTaH(PTaH_GiveNamedItemPre, Hook, GiveNamedItemPre);
    PTaH(PTaH_GiveNamedItemPost, Hook, GiveNamedItemPost);
}