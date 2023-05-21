#include <sourcemod>
#include <sdktools>
#include <PTaH>

#include "items.sp"

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

char knife_names[][] = {
    "weapon_bayonet",
    "weapon_knife_css",
    "weapon_knife_flip",
    "weapon_knife_gut",
    "weapon_knife_karambit",       
    "weapon_knife_m9_bayonet",     
    "weapon_knife_tactical",       
    "weapon_knife_falchion",       
    "weapon_knife_survival_bowie", 
    "weapon_knife_butterfly",      
    "weapon_knife_push",
    "weapon_knife_cord",
    "weapon_knife_canis",
    "weapon_knife_ursus",
    "weapon_knife_gypsy_jackknife",
    "weapon_knife_outdoor",        
    "weapon_knife_stiletto",
    "weapon_knife_widowmaker",
    "weapon_knife_skeleton"
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
        int knife_index = GetRandomInt(0, sizeof(knife_names));
        strcopy(classname, sizeof(classname), knife_names[knife_index]);
        return Plugin_Changed;
    }
    return Plugin_Continue;
}

void GiveNamedItemPost(int client, const char[] classname, const CEconItemView item, int entity, bool OriginIsNULL, const float Origin[3])
{
    if(IsValidEntity(entity))
    {
        int weapon_id = GetEntProp(entity, Prop_Send, "m_iItemDefinitionIndex");
        if (GetWeaponIndexFromWeaponId(weapon_id) == -1)
        {
            return;
        }
        int random_skin = GetRandomSkinFromWeaponId(weapon_id);
        PrintToConsole(client, "SkinId: %i", random_skin);
        SetEntProp(entity, Prop_Send, "m_nFallbackPaintKit", random_skin);
        SetEntProp(entity, Prop_Send, "m_iItemIDHigh", -1);
        SetEntProp(entity, Prop_Send, "m_iItemIDLow", -1);
        if(StrContains(classname, "knife") != -1 || StrContains(classname, "bayonet") != -1)
        {
            SetEntProp(entity, Prop_Send, "m_iEntityQuality", 3);
        }
    }
}

public void OnPluginStart()
{
    PTaH(PTaH_WeaponCanUsePre, Hook, WeaponCanUsePre);
    PTaH(PTaH_GiveNamedItemPre, Hook, GiveNamedItemPre);
    PTaH(PTaH_GiveNamedItemPost, Hook, GiveNamedItemPost);

    RegConsoleCmd("log_skins", LogSkins);
}

public Action LogSkins(int client, int args)
{
    PrintToConsole(client, "Not implemented yet.");
    // int weapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
    // int weapon_id = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
    // int weapon_index = GetWeaponIndexFromWeaponId(weapon_id);
    // char[][] skin_names = items_weapon_names[weapon_index];
    // int[] skin_ids = items_weapon_ids[weapon_index];
    // PrintToConsole(client, "Name Size: %i", sizeof(skin_names));
    // PrintToConsole(client, "  Id Size: %i", sizeof(skin_ids));
    // for (int i = 0; i < sizeof(skin_names); i++)
    // {
    //     PrintToConsole(client, "%s = %i", skin_names[i], skin_ids[i]);
    // }
    return Plugin_Handled;
}