-- More trees!  2013-04-07
--
-- This mod adds more types of trees to the game
--
-- Some of the node definitions and textures came from cisoun's conifers mod
-- and bas080's jungle trees mod.
--
-- Brought together into one mod and made L-systems compatible by Vanessa
-- Ezekowitz.
--
-- Firs and Jungle tree axioms/rules by Vanessa Dannenberg, with the
-- latter having been tweaked by RealBadAngel, most other axioms/rules written
-- by RealBadAngel.
--

moretrees = {}

minetest.override_item("default:sapling", {
	description = "Sapling"
})

minetest.override_item("default:tree", {
	description = "Tree"
})

minetest.override_item("default:wood", {
	description = "Wooden Planks"
})

minetest.override_item("default:leaves", {
	description = "Leaves"
})

minetest.override_item("default:fence_wood", {
	description = "Wooden Fence"
})

minetest.override_item("default:fence_rail_wood", {
	description = "Wooden Fence Rail"
})

if minetest.get_modpath("doors") then
	minetest.override_item("doors:gate_wood_closed", {
		description = "Wooden Fence Gate"
	})

	minetest.override_item("doors:gate_wood_open", {
		description = "Wooden Fence Gate"
	})
end


-- Read the default config file (and if necessary, copy it to the world folder).

local worldpath=minetest.get_worldpath()
local modpath=minetest.get_modpath("moretrees")

dofile(modpath.."/settings.lua")

if io.open(worldpath.."/moretrees_settings.txt","r") then
	io.close()
	dofile(worldpath.."/moretrees_settings.txt")
end


-- infinite stacks checking

if minetest.get_modpath("unified_inventory") or not
		minetest.settings:get_bool("creative_mode") then
	moretrees.expect_infinite_stacks = false
else
	moretrees.expect_infinite_stacks = true
end

-- tables, load other files

moretrees.cutting_tools = {
	"default:axe_bronze",
	"default:axe_diamond",
	"default:axe_mese",
	"default:axe_steel",
	"glooptest:axe_alatro",
	"glooptest:axe_arol",
	"moreores:axe_mithril",
	"moreores:axe_silver",
	"titanium:axe",
}

dofile(modpath.."/tree_models.lua")
dofile(modpath.."/node_defs.lua")
dofile(modpath.."/date_palm.lua")
dofile(modpath.."/cocos_palm.lua")
dofile(modpath.."/biome_defs.lua")
dofile(modpath.."/saplings.lua")
dofile(modpath.."/crafts.lua")

-- tree spawning setup
moretrees.spawn_beech_object = moretrees.beech_model
moretrees.spawn_apple_tree_object = moretrees.apple_tree_model
moretrees.spawn_oak_object = moretrees.oak_model
moretrees.spawn_sequoia_object = moretrees.sequoia_model
moretrees.spawn_palm_object = moretrees.palm_model
moretrees.spawn_date_palm_object = moretrees.date_palm_model
moretrees.spawn_cedar_object = moretrees.cedar_model
moretrees.spawn_rubber_tree_object = moretrees.rubber_tree_model
moretrees.spawn_willow_object = moretrees.willow_model
moretrees.spawn_birch_object = "moretrees.grow_birch"
moretrees.spawn_spruce_object = "moretrees.grow_spruce"
moretrees.spawn_jungletree_object = "moretrees.grow_jungletree"
moretrees.spawn_fir_object = "moretrees.grow_fir"
moretrees.spawn_fir_snow_object = "moretrees.grow_fir_snow"
moretrees.spawn_poplar_object = moretrees.poplar_model
moretrees.spawn_poplar_small_object = moretrees.poplar_small_model

local deco_ids = {}

function translate_biome_defs(def, treename, index)
	if not index then index = 1 end
	local deco_def = {
		name = treename .. "_" .. index,
		deco_type = "simple",
		place_on = def.place_on or def.surface,
		sidelen = 16,
		fill_ratio = def.fill_ratio or 0.001,
		--biomes eventually?
		y_min = def.min_elevation,
		y_max = def.max_elevation,
		spawn_by = def.near_nodes,
		num_spawn_by = def.near_nodes_count,
		decoration = "moretrees:"..treename.."_sapling_ongen"
	}

	deco_ids[#deco_ids+1] = treename .. ("_" .. index or "_1")

	return deco_def
end

if moretrees.enable_beech then
	minetest.register_decoration(translate_biome_defs(moretrees.beech_biome, "beech"))
end

if moretrees.enable_apple_tree then
	minetest.register_decoration(translate_biome_defs(moretrees.apple_tree_biome, "apple_tree"))
end

if moretrees.enable_oak then
	minetest.register_decoration(translate_biome_defs(moretrees.oak_biome, "oak"))
end

if moretrees.enable_sequoia then
	minetest.register_decoration(translate_biome_defs(moretrees.sequoia_biome, "sequoia"))
end

if moretrees.enable_palm then
	minetest.register_decoration(translate_biome_defs(moretrees.palm_biome, "palm"))
end

if moretrees.enable_date_palm then
	minetest.register_decoration(translate_biome_defs(moretrees.date_palm_biome, "palm", 1))
	minetest.register_decoration(translate_biome_defs(moretrees.date_palm_biome_2, "palm", 2))
end

if moretrees.enable_cedar then
	minetest.register_decoration(translate_biome_defs(moretrees.cedar_biome, "cedar"))
end

if moretrees.enable_rubber_tree then
	minetest.register_decoration(translate_biome_defs(moretrees.rubber_tree_biome, "ruber"))
end

if moretrees.enable_willow then
	minetest.register_decoration(translate_biome_defs(moretrees.willow_biome, "willow"))
end

if moretrees.enable_birch then
	minetest.register_decoration(translate_biome_defs(moretrees.birch_biome, "birch"))
end

if moretrees.enable_spruce then
	minetest.register_decoration(translate_biome_defs(moretrees.spruce_biome, "spruce"))
end

if moretrees.enable_jungle_tree then
	minetest.register_decoration(translate_biome_defs(moretrees.jungletree_biome, "jungletree"))
end

if moretrees.enable_fir then
	minetest.register_decoration(translate_biome_defs(moretrees.fir_biome, "fir", 1))
	if minetest.get_modpath("snow") then
		minetest.register_decoration(translate_biome_defs(moretrees.fir_biome_snow, "fir", 2))
	end
end

if moretrees.enable_poplar then
	minetest.register_decoration(translate_biome_defs(moretrees.poplar_biome, "popular", 1))
	minetest.register_decoration(translate_biome_defs(moretrees.poplar_biome_2, "popular", 2))
	minetest.register_decoration(translate_biome_defs(moretrees.poplar_biome_3, "popular", 3))
	minetest.register_decoration(translate_biome_defs(moretrees.poplar_small_biome, "popular", 4))
	minetest.register_decoration(translate_biome_defs(moretrees.poplar_small_biome_2, "popular", 5))
end

for k, v in pairs(deco_ids) do
	deco_ids[k] = minetest.get_decoration_id(v)
end
minetest.set_gen_notify("decoration", deco_ids)

minetest.register_on_generated(function(minp, maxp, blockseed)
    local g = minetest.get_mapgen_object("gennotify")
	--minetest.chat_send_all(dump(g))
    local locations = {}
	for _, id in pairs(deco_ids) do
		local deco_locations = g["decoration#" .. id] or {}
		for _, pos in pairs(deco_locations) do
			locations[#locations+1] = pos
		end
	end

    if #locations == 0 then return end
    for _, pos in ipairs(locations) do
		--minetest.chat_send_all("yay")
        local timer = minetest.get_node_timer({x=pos.x, y=pos.y+1, z=pos.z})
        timer:start(math.random(2,10))
		--minetest.set_node(pos, {name="default:stone"})
    end
end)

-- Code to spawn a birch tree

function moretrees.grow_birch(pos)
	minetest.swap_node(pos, {name = "air"})
	if math.random(1,2) == 1 then
		minetest.spawn_tree(pos, moretrees.birch_model1)
	else
		minetest.spawn_tree(pos, moretrees.birch_model2)
	end
end

-- Code to spawn a spruce tree

function moretrees.grow_spruce(pos)
	minetest.swap_node(pos, {name = "air"})
	if math.random(1,2) == 1 then
		minetest.spawn_tree(pos, moretrees.spruce_model1)
	else
		minetest.spawn_tree(pos, moretrees.spruce_model2)
	end
end

-- Code to spawn jungle trees

moretrees.jt_axiom1 = "FFFA"
moretrees.jt_rules_a1 = "FFF[&&-FBf[&&&Ff]^^^Ff][&&+FBFf[&&&FFf]^^^Ff][&&---FBFf[&&&Ff]^^^Ff][&&+++FBFf[&&&Ff]^^^Ff]F/A"
moretrees.jt_rules_b1 = "[-Ff&f][+Ff&f]B"

moretrees.jt_axiom2 = "FFFFFA"
-- luacheck: no max line length
moretrees.jt_rules_a2 = "FFFFF[&&-FFFBF[&&&FFff]^^^FFf][&&+FFFBFF[&&&FFff]^^^FFf][&&---FFFBFF[&&&FFff]^^^FFf][&&+++FFFBFF[&&&FFff]^^^FFf]FF/A"
moretrees.jt_rules_b2 = "[-FFf&ff][+FFf&ff]B"

moretrees.ct_rules_a1 = "FF[FF][&&-FBF][&&+FBF][&&---FBF][&&+++FBF]F/A"
moretrees.ct_rules_b1 = "[-FBf][+FBf]"

moretrees.ct_rules_a2 = "FF[FF][&&-FBF][&&+FBF][&&---FBF][&&+++FBF]F/A"
moretrees.ct_rules_b2 = "[-fB][+fB]"

function moretrees.grow_jungletree(pos)
	local r1 = math.random(2)
	local r2 = math.random(3)
	if r1 == 1 then
		moretrees.jungletree_model.leaves2 = "moretrees:jungletree_leaves_red"
	else
		moretrees.jungletree_model.leaves2 = "moretrees:jungletree_leaves_yellow"
	end
	moretrees.jungletree_model.leaves2_chance = math.random(25, 75)

	if r2 == 1 then
		moretrees.jungletree_model.trunk_type = "single"
		moretrees.jungletree_model.iterations = 2
		moretrees.jungletree_model.axiom = moretrees.jt_axiom1
		moretrees.jungletree_model.rules_a = moretrees.jt_rules_a1
		moretrees.jungletree_model.rules_b = moretrees.jt_rules_b1
	elseif r2 == 2 then
		moretrees.jungletree_model.trunk_type = "double"
		moretrees.jungletree_model.iterations = 4
		moretrees.jungletree_model.axiom = moretrees.jt_axiom2
		moretrees.jungletree_model.rules_a = moretrees.jt_rules_a2
		moretrees.jungletree_model.rules_b = moretrees.jt_rules_b2
	elseif r2 == 3 then
		moretrees.jungletree_model.trunk_type = "crossed"
		moretrees.jungletree_model.iterations = 4
		moretrees.jungletree_model.axiom = moretrees.jt_axiom2
		moretrees.jungletree_model.rules_a = moretrees.jt_rules_a2
		moretrees.jungletree_model.rules_b = moretrees.jt_rules_b2
	end

	minetest.swap_node(pos, {name = "air"})
	local leaves = minetest.find_nodes_in_area(
		{x = pos.x-1, y = pos.y, z = pos.z-1}, {x = pos.x+1, y = pos.y+10, z = pos.z+1},
		"default:leaves"
	)
	for leaf in ipairs(leaves) do
			minetest.swap_node(leaves[leaf], {name = "air"})
	end
	minetest.spawn_tree(pos, moretrees.jungletree_model)
end

-- code to spawn fir trees

function moretrees.grow_fir(pos)
	if math.random(2) == 1 then
		moretrees.fir_model.leaves="moretrees:fir_leaves"
	else
		moretrees.fir_model.leaves="moretrees:fir_leaves_bright"
	end
	if math.random(2) == 1 then
		moretrees.fir_model.rules_a = moretrees.ct_rules_a1
		moretrees.fir_model.rules_b = moretrees.ct_rules_b1
	else
		moretrees.fir_model.rules_a = moretrees.ct_rules_a2
		moretrees.fir_model.rules_b = moretrees.ct_rules_b2
	end

	moretrees.fir_model.iterations = 7
	moretrees.fir_model.random_level = 5

	minetest.swap_node(pos, {name = "air"})
	local leaves = minetest.find_nodes_in_area(
		{x = pos.x, y = pos.y, z = pos.z},
		{x = pos.x, y = pos.y+5, z = pos.z},
		"default:leaves"
	)
	for leaf in ipairs(leaves) do
		minetest.swap_node(leaves[leaf], {name = "air"})
	end
	minetest.spawn_tree(pos,moretrees.fir_model)
end

-- same thing, but a smaller version that grows only in snow biomes

function moretrees.grow_fir_snow(pos)
	if math.random(2) == 1 then
		moretrees.fir_model.leaves="moretrees:fir_leaves"
	else
		moretrees.fir_model.leaves="moretrees:fir_leaves_bright"
	end
	if math.random(2) == 1 then
		moretrees.fir_model.rules_a = moretrees.ct_rules_a1
		moretrees.fir_model.rules_b = moretrees.ct_rules_b1
	else
		moretrees.fir_model.rules_a = moretrees.ct_rules_a2
		moretrees.fir_model.rules_b = moretrees.ct_rules_b2
	end

	moretrees.fir_model.iterations = 2
	moretrees.fir_model.random_level = 2

	minetest.swap_node(pos, {name = "air"})
	local leaves = minetest.find_nodes_in_area(
		{x = pos.x, y = pos.y, z = pos.z},
		{x = pos.x, y = pos.y+5, z = pos.z},
		"default:leaves"
	)
	for leaf in ipairs(leaves) do
			minetest.swap_node(leaves[leaf], {name = "air"})
	end
	minetest.spawn_tree(pos,moretrees.fir_model)
end

print("[Moretrees] Loaded (2013-02-11)")
