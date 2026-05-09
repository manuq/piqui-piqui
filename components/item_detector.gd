@tool
class_name ItemDetector
extends Area2D

@export var character: PiquiCharacter

signal collected

var global_z_index: int

func _enter_tree() -> void:
	if get_parent() is PiquiCharacter:
		character = get_parent()

func _ready() -> void:
	area_entered.connect(on_area_entered)
	character.floor_changed.connect(on_floor_changed)

func on_floor_changed() -> void:
	global_z_index = Globals.get_absolute_z_index(character)

func on_area_entered(area: Area2D) -> void:
	var c := area.owner as CanvasItem
	if not c:
		return
	if Globals.get_absolute_z_index(c) == global_z_index:
		collected.emit()
		area.owner.queue_free()
