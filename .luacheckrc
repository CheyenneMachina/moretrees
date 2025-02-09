unused_args = false
allow_defined_top = true

exclude_files = {".luacheckrc"}


globals = {
	"minetest",
	"vector",
	"VoxelManip",
	"VoxelArea",
	"PseudoRandom",
	"ItemStack",
	"default",
	"dump",
	"moretrees",
}

read_globals = {
	string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

	"biome_lib",
	"stairsplus",
	"stairs",
	"doors",
}
