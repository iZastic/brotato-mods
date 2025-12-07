extends "res://main.gd"


var share_common_crate
var share_legendary_crate
var endless_legendary_crates


func _ready() -> void:
	var config = ModLoaderConfig.get_current_config("iZastic-CrateOptions")
	share_common_crate = config.data.SHARE_COMMON_CRATES
	share_legendary_crate = config.data.SHARE_LEGENDARY_CRATES
	endless_legendary_crates = config.data.ENDLESS_LEGENDARY_CRATES


func spawn_consumables(unit: Unit) -> void:
	if endless_legendary_crates:
		var current_wave = RunData.current_wave
		RunData.current_wave = RunData.nb_of_waves
		.spawn_consumables(unit)
		RunData.current_wave = current_wave
	else:
		.spawn_consumables(unit)


func on_consumable_picked_up(consumable: Node, player_index: int) -> void:
	# Do standard pickup if it's not an item box
	# Do standard pickup if it's an item box but sharing is disabled
	# Do standark pickup if it's a legendary box but sharing legendary is disabled
	if (consumable.consumable_data.my_id != "consumable_item_box" and consumable.consumable_data.my_id != "consumable_legendary_item_box") \
	or (!share_common_crate and consumable.consumable_data.my_id != "consumable_item_box") \
	or (!share_legendary_crate and consumable.consumable_data.my_id != "consumable_legendary_item_box"):
		.on_consumable_picked_up(consumable, player_index)
		return

	# Create additional consumables for other players using code similar to spawn_consumables
	var consumables = [consumable]
	for _i in range(RunData.get_player_count() - 1):
		var _consumable: Consumable = _duplicate_consumable(consumable)
		_consumables.push_back(_consumable) # scene list
		consumables.push_back(_consumable) # temp list

	for _player_index in range(RunData.get_player_count()):
		.on_consumable_picked_up(consumables[_player_index], _player_index)


func _duplicate_consumable(consumable: Consumable) -> Consumable:
	var _consumable: Consumable = get_node_from_pool(consumable_scene.resource_path)
	if _consumable == null:
		_consumable = consumable_scene.instance()
		_consumables_container.call_deferred("add_child", _consumable)
		_consumable.connect("picked_up", self, "on_consumable_picked_up")
	_consumable.consumable_data = consumable.consumable_data
	_consumable.already_picked_up = false
	_consumable.set_texture(consumable.sprite.texture)
	return _consumable
