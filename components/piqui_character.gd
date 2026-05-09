@tool
class_name PiquiCharacter
extends CharacterBody2D

signal floor_changed

@export var current_floor := 0:
	set = set_current_floor

@onready var floor_rays: Node2D = %FloorRays
@onready var above_ray: RayCast2D = %AboveRay
@onready var below_ray: RayCast2D = %BelowRay

var on_rails: bool = false

func set_current_floor(new_current_floor: int) -> void:
	current_floor = new_current_floor
	if not is_node_ready():
		return

	z_index = 10 * current_floor

	for c in floor_rays.get_children():
		if c is not RayCast2D:
			continue
		var r := c as RayCast2D
		r.collision_mask = 0
		r.set_collision_mask_value(Globals.floor_layer_from_int[current_floor], true)

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
	set_current_floor(current_floor)
