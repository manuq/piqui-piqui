@tool
extends PointLight2D

@export var character: PiquiCharacter

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)

func _process(_delta: float) -> void:
	if character.on_rails:
		visible = false
		return
	if character.above_ray.is_colliding():
		visible = true
		range_item_cull_mask = 1 << Globals.floor_layer_from_int[character.current_floor + 1]
		global_position = character.above_ray.global_position + character.above_ray.target_position
	elif character.below_ray.is_colliding():
		visible = true
		range_item_cull_mask = 1 << Globals.floor_layer_from_int[character.current_floor - 1]
		global_position = character.below_ray.global_position + character.below_ray.target_position
	else:
		visible = false
