extends Node

@export var character: PiquiCharacter

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if character.on_rails:
		return
	if event.is_action_released("jump"):
		if character.above_ray.is_colliding():
			jump(character.above_ray.global_position + character.above_ray.target_position, character.current_floor + 1)
		elif character.below_ray.is_colliding():
			jump(character.below_ray.global_position + character.below_ray.target_position, character.current_floor - 1)

func _physics_process(_delta: float) -> void:
	flip_above_below_rays()

func flip_above_below_rays() -> void:
	if not is_zero_approx(character.velocity.x):
		character.above_ray.position.x = 64 * sign(character.velocity.x)
		character.below_ray.position.x = 64 * sign(character.velocity.x)

func jump(end_pos: Vector2, new_floor: int) -> void:
	character.on_rails = true
	var tween := get_tree().create_tween().set_parallel(true)		
	var between_y: float = min(character.global_position.y, end_pos.y) - 32
	tween.tween_property(character, "global_position:x", end_pos.x, 0.2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(character, "global_position:y", between_y, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(character, "global_position:y", end_pos.y, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_delay(0.1)
	tween.tween_callback(on_mid_air.bind(new_floor)).set_delay(0.1)
	await tween.finished
	character.on_rails = false

func on_mid_air(new_floor: int) -> void:
	character.current_floor = new_floor
	
