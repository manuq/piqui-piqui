@tool
class_name PiquiWalk
extends Node2D

@export var character: PiquiCharacter

@export var speed := 400.0

@export_group("Debug", "debug")
@export var debug_skip_on_air := false
@export var debug_skip_floor_detection := false
@export var debug_draw := false

## The player input direction.
var input_direction: Vector2

## The closest axis according to player input direction.
var axis: Vector2i

## The last non-zero axis, for walking like pac-man.
var last_axis: Vector2i

## The axis of the actual moving direction.
## If there is no corridor at the last axis direction,
## the character will continue moving this way.
var move_axis: Vector2i

## The direction to move the character to stand on floor again.
## This is zero if the character fully stands on floor
## or fully floats on air.
## This is a unit vector.
var floor_direction: Vector2

var is_setup: bool = false

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()

func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		return
	# character.floor_changed.connect(on_floor_changed)

func _unhandled_input(_event: InputEvent) -> void:
	if character.on_rails:
		return
	input_direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	axis = Globals.get_closest_axis(input_direction)
	if axis != Vector2i.ZERO:
		last_axis = axis
		character.facing_direction = Vector2(last_axis)


func _draw() -> void:
	if not debug_draw:
		return
	draw_line(Vector2.ZERO, Vector2(last_axis) * 128, Color.YELLOW, 1.0)
	draw_line(Vector2(1, 1), Vector2(1, 1) + floor_direction.normalized() * 128, Color.BLUE, 1.0)


func _physics_process(_delta: float) -> void:
	if not is_setup:
		if character.current_floor_layer:
			var coord := Globals.global_position_to_tile_coordinate(character.current_floor_layer, character.global_position)
			var tile_center := Globals.tile_coordinate_to_global_position(character.current_floor_layer, coord)
			character.global_position = tile_center
			is_setup = true

	else:
		if character.current_floor_layer and last_axis:
			var coord := Globals.global_position_to_tile_coordinate(character.current_floor_layer, character.global_position)
			var tile_center := Globals.tile_coordinate_to_global_position(character.current_floor_layer, coord)
			if Vector2(move_axis).normalized().dot(Vector2(last_axis).normalized()) < -0.99:
				move_axis = Vector2(last_axis)
			elif (character.global_position - tile_center).length_squared() < 15.0:
				var neighbor := Globals.NEIGHBORS_FOR_AXIS[last_axis]
				character.global_position = tile_center
				var new_coord := character.current_floor_layer.get_neighbor_cell(coord, neighbor)
				var data := character.current_floor_layer.get_cell_tile_data(new_coord)
				if data:
					move_axis = last_axis
				elif move_axis:
					var move_axis_neighbor := Globals.NEIGHBORS_FOR_AXIS[move_axis]
					var move_axis_new_coord := character.current_floor_layer.get_neighbor_cell(coord, move_axis_neighbor)
					var move_data := character.current_floor_layer.get_cell_tile_data(move_axis_new_coord)
					if not move_data:
						move_axis = Vector2i.ZERO
			character.velocity = Vector2(move_axis) * speed
			character.move_and_slide()

	if debug_draw:
		queue_redraw()
