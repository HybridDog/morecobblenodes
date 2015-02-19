local load_time_start = os.clock()

local function add_stair(name, data)
	data.groups.stone = nil
	stairs.register_stair_and_slab("morecobblenodes_"..name, "morecobblenodes:"..name,
		data.groups,
		data.tiles,
		data.description.." Stair",
		data.description.." Slab",
		data.sounds
	)
end

local moss_found = rawget(_G, "moss")
local function register_node(name, data)
	minetest.register_node("morecobblenodes:"..name, table.copy(data))
	local stair = not data.no_stair
	if stair then
		add_stair(name, table.copy(data))
	end
	if moss_found then
		data.tiles = data.moss
		if data.tiles then
			data.description = "Mossy "..data.description
			local mossname = name.."_mossy"
			if stair then
				add_stair(mossname, table.copy(data))
			end
			minetest.register_node("morecobblenodes:"..mossname, data)
			moss.register_moss({
				node = name,
				result = mossname
			})
		end
	end
end

register_node("stones_big", {
	description = "Big Stones",
	tiles = {"morecobblenodes_stones_big.png"},
	moss = {"morecobblenodes_stones_big_mossy.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

register_node("stones_middle", {
	description = "Stones",
	tiles = {"morecobblenodes_stones_middle.png"},
	moss = {"morecobblenodes_stones_middle_mossy.png"},
	groups = {cracky=3, stone=2},
	sounds = default.node_sound_stone_defaults(),
})

register_node("stonebrick_middle", {
	description = "Stone Brick",
	tiles = {"morecobblenodes_stone_brick_middle.png"},
	moss = {"morecobblenodes_stone_brick_middle_mossy.png"},
	groups = {cracky=3, stone=2},
	sounds = default.node_sound_stone_defaults(),
})

register_node("sand_and_dirt", {
	description = "Sand Dirt mixed",
	tiles = {"morecobblenodes_sand_and_dirt.png"},
	groups = {crumbly=3, soil=1, falling_node=1, sand=1},
	sounds = default.node_sound_dirt_defaults(),
	no_stair = true
})


--recipes
if rawget(_G, "technic")
and technic.register_separating_recipe then
	local recipes = {
		{"default:cobble 2", "morecobblenodes:stones_big", "default:gravel"},
		{"default:gravel 2", "morecobblenodes:stones_middle", "morecobblenodes:sand_and_dirt"},
		{"morecobblenodes:sand_and_dirt 2", "default:sand", "default:dirt"},
	}
	for _,i in pairs(recipes) do
		technic.register_separating_recipe({input={i[1]}, output={i[2], i[3]}})
	end
end

minetest.log("info", string.format("[morecobblenodes] loaded after ca. %.2fs", os.clock() - load_time_start))
