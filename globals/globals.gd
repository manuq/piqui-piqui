class_name Globals

const floor_layer_from_int: Dictionary[int, CollisionLayers] = {
	0: CollisionLayers.FLOOR_0,
	1: CollisionLayers.FLOOR_1,
	2: CollisionLayers.FLOOR_2,
}

enum CollisionLayers {
	FLOOR_0 = 5,
	FLOOR_1 = 6,
	FLOOR_2 = 7,
}

static func get_closest_axis(vector: Vector2) -> Vector2i:
	if abs(vector.x) > abs(vector.y):
		return Vector2i(sign(vector.x), 0)
	return Vector2i(0, sign(vector.y))

static func get_absolute_z_index(canvas_item: CanvasItem) -> int:
	var result := canvas_item.z_index
	var current = canvas_item.get_parent() as CanvasItem

	while current and canvas_item.z_as_relative:
		result += current.z_index
		if not current.z_as_relative:
			break
		current = current.get_parent() as CanvasItem

	return result
