import vdf
import json

# This is so inefficiently made LMFAO but it's made to parse the items_game.txt not be fast :)

ig = vdf.load(open("items_game.txt"))


if ig.get("items_game") is None:
    print("Idk")
    exit()

weapons1 = {}

for id, info in ig.get("items_game").get("items").items():
    if id.isdigit() and info.get("name"):
        weapons1[info.get("name")] = id

skins1 = {}

for id, info in ig.get("items_game").get("paint_kits").items():
    if id.isdigit() and info.get("name"):
        skins1[info.get("name")] = id

skins2 = {}

for thing in ig.get("items_game").get("alternate_icons2").get("weapon_icons").values():
    path = thing.get("icon_path")
    if not path:
        continue
    if path.endswith("_light"):
        path = path.replace("econ/default_generated/", "")
        path = path.replace("_light", "")
        for skin in skins1.keys():
            if path.endswith(skin):
                if not skin in skins2:
                    skins2[skin] = [path.replace("_" + skin, "")]
                else:
                    skins2[skin] += [path.replace("_" + skin, "")]

skins3 = {}

for skin, weapons in skins2.items():
    for weapon in weapons:
        if weapon not in skins3:
            skins3[weapon] = [skin]
        else:
            skins3[weapon] += [skin]

skins4 = {}

for weapon, skins in skins3.items():
    skins4[weapon] = []
    for skin in skins:
        if skin in skins:
            skins4[weapon] += [skins1[skin]]
        else:
            print("Skin not found: " + skin)

skins5 = {}

for weapon, skins in skins4.items():
    if weapon in weapons1:
        skins5[weapons1[weapon]] = skins
    else:
        print("Weapon not found: " + weapon)

f = open('items_game6.json', 'w')
json.dump(skins5, f, indent=4)

f = open('items.sp', 'w')
f.write("// ############################################\n")
f.write("// #                                          #\n")
f.write("// #   Generated with ./parse_items_game.py   #\n")
f.write("// #                                          #\n")
f.write("// ############################################\n\n")

f.write("int items_weapon_ids[] = { ")
for weapon in skins5.keys():
    f.write(f"{weapon}")

    if list(skins5.keys())[-1] != weapon:
        f.write(", ")
    else:
        f.write(" };\n")

f.write("int items_weapon_skin_count[] = { ")
for weapon, skins in skins5.items():
    f.write(f"{len(skins)}")

    if list(skins5.keys())[-1] != weapon:
        f.write(", ")
    else:
        f.write(" };\n")

f.write("int items_weapon_skin_ids[][] = {\n")
for weapon, skins in skins5.items():
    f.write("    { ")
    for skin in skins:
        f.write(f"{skin}")

        # if not last skin write a comma
        if skin != skins[-1]:
            f.write(", ")
        else:
            f.write(" }")
    
    # if not last weapon write a comma
    if weapon != list(skins5.keys())[-1]:
        f.write(",\n")
    else:
        f.write("\n};\n\n")

f.write("int GetWeaponIndexFromWeaponId(int weapon_id)\n")
f.write("{\n")
f.write("    for (int i = 0; i < sizeof(items_weapon_ids); i++)\n")
f.write("    {\n")
f.write("        if (items_weapon_ids[i] == weapon_id)\n")
f.write("        {\n")
f.write("            return i;\n")
f.write("        }\n")
f.write("    }\n")
f.write("\n")
f.write("    return -1;\n")
f.write("}\n")
f.write("\n")
f.write("int GetRandomSkinFromWeaponId(int weapon_id)\n")
f.write("{\n")
f.write("    int weapon_index = GetWeaponIndexFromWeaponId(weapon_id);\n")
f.write("\n")
f.write("    if (weapon_index == -1)\n")
f.write("    {\n")
f.write("        return 0;\n")
f.write("    }\n")
f.write("\n")
f.write("    int skin_count = items_weapon_skin_count[weapon_index];\n")
f.write("    int skin_index = GetRandomInt(0, skin_count - 1);\n")
f.write("    return items_weapon_skin_ids[weapon_index][skin_index];\n")
f.write("}\n")