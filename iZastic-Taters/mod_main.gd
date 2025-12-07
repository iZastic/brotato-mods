extends Node

const MOD_ID := "iZastic-Taters"
const LOG_ID := MOD_ID + ":Main" # Full ID of the mod (iZastic-Taters)

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init() -> void:
	ModLoaderLog.info("Init", LOG_ID)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(MOD_ID)

	install_script_extensions()
	add_translations()


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_ID)

	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")

	var content_dir_path = mod_dir_path.plus_file("content_data")
	ContentLoader.load_data(content_dir_path + "/taters_sets.tres", MOD_ID)
	ContentLoader.load_data(content_dir_path + "/weapons/ranged/boomerang.tres", MOD_ID)
	ContentLoader.load_data(content_dir_path + "/weapons/ranged/snowball.tres", MOD_ID)


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.plus_file("extensions")

	# ? Brief description/reason behind this edit of vanilla code...
	# ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("main.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	ModLoaderMod.add_translation(translations_dir_path.plus_file("taters.en.translation"))
