extends Node

@export var character: PiquiCharacter

@export var speed := 400.0

@export var bounce := false

@export_group("Debug", "debug")
@export var debug_skip_floor := false


var axis: Vector2i

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()

func _unhandled_input(_event: InputEvent) -> void:
	if character.on_rails:
		return
	var input_vector := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	axis = Globals.get_closest_axis(input_vector)

func _physics_process(_delta: float) -> void:
	var no_floor := false
	if not debug_skip_floor:
		for c in character.floor_rays.get_children():
			if c is not RayCast2D:
				continue
			var r := c as RayCast2D
			if not r.is_colliding():
				no_floor = true
				character.position -= r.target_position.normalized()
				if bounce:
					character.velocity = Globals.get_closest_axis(r.target_position) * -1 * speed
				else:
					character.velocity = Vector2.ZERO
				break
	if no_floor:
		pass
	elif axis:
		character.velocity = axis * speed
	
	character.move_and_slide()
