@tool
class_name PiquiCharacter
extends CharacterBody2D

signal floor_changed

@export var facing_direction: Vector2

@export var current_floor := 0:
	set = set_current_floor

@onready var floor_ray: RayCast2D = %FloorRay
@onready var above_ray: RayCast2D = %AboveRay
@onready var below_ray: RayCast2D = %BelowRay

## This will be true only if the character is fully floating on air.
## That is, if at least one part of the character's floor detection
## are on air this will still be false.
var floating_on_air: bool = false:
	set = set_floating_on_air

var on_rails: bool = false

var current_floor_layer: TileMapLayer

func set_floating_on_air(new_floating_on_air: bool) -> void:
	if floating_on_air == new_floating_on_air:
		return
	floating_on_air = new_floating_on_air
	if not is_node_ready():
		return
	modulate = Color(1.0, 1.0, 1.0, 0.5) if floating_on_air else Color.WHITE

func set_current_floor(new_current_floor: int) -> void:
	current_floor = new_current_floor
	if not is_node_ready():
		return

	z_index = 10 * current_floor

	floor_ray.collision_mask = 0
	floor_ray.set_collision_mask_value(Globals.floor_layer_from_int[current_floor], true)
	above_ray.enabled = current_floor < 2
	below_ray.enabled = current_floor > 0
	if above_ray.enabled:
		above_ray.collision_mask = 0
		above_ray.set_collision_mask_value(Globals.floor_layer_from_int[current_floor + 1], true)
	if below_ray.enabled:
		below_ray.collision_mask = 0
		below_ray.set_collision_mask_value(Globals.floor_layer_from_int[current_floor - 1], true)

	floor_changed.emit()


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		return
	set_current_floor(current_floor)


func _physics_process(_delta: float) -> void:
	if floor_ray.is_colliding() and floor_ray.get_collision_point() == floor_ray.global_position:
		current_floor_layer = floor_ray.get_collider() as TileMapLayer
	else:
		current_floor_layer = null
