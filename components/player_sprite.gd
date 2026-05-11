@tool
extends AnimatedSprite2D

@export var character: PiquiCharacter
@export var item_detector: ItemDetector

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
	item_detector.collected.connect(on_item_collected)

func on_item_collected() -> void:
	if is_playing() and animation == "attack":
		stop()
		flip()
	play("attack")

func flip() -> void:
	if not is_zero_approx(character.facing_direction.x):
		flip_h = character.facing_direction.x < 0

func _process(_delta: float) -> void:
	if not character:
		return
	if is_playing() and animation == "attack":
		return
	if character.velocity.is_zero_approx():
		play("idle")
	else:
		play("walk")
	flip()
