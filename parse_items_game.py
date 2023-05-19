import vdf
import json

# This is so inefficiently made LMFAO but it's made to parse the items_game.txt not be fast :)

ig = vdf.load(open("items_game.txt"))

f = open('items_game2.txt', 'w')

if ig.get("items_game") is None:
    print("Idk")
    exit()

skins = {}

for id, info in ig.get("items_game").get("paint_kits").items():
    if id.isdigit() and info.get("name"):
        skins[info.get("name")] = id

skins2 = {}

for thing in ig.get("items_game").get("alternate_icons2").get("weapon_icons").values():
    path = thing.get("icon_path")
    if not path:
        continue
    if path.endswith("_light"):
        path = path.replace("econ/default_generated/", "")
        path = path.replace("_light", "")
        for skin in skins.keys():
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

