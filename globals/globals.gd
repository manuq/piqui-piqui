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

const NEIGHBORS_FOR_AXIS: Dictionary[Vector2i, TileSet.CellNeighbor] = {
	Vector2i.DOWN: TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
	Vector2i.LEFT: TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	Vector2i.UP: TileSet.CELL_NEIGHBOR_TOP_SIDE,
	Vector2i.RIGHT: TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
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

static func global_position_to_tile_coordinate(constrain_layer: TileMapLayer, global_pos: Vector2) -> Vector2i:
	return constrain_layer.local_to_map(constrain_layer.to_local(global_pos))

static func tile_coordinate_to_global_position(constrain_layer: TileMapLayer, coord: Vector2i) -> Vector2:
	return constrain_layer.to_global(constrain_layer.map_to_local(coord))
