extends Node2D

const single_tile_scene = preload("res://Scenes/SingleTileGrey.tscn")
const tile_width = 32

func _add_tile_at(x, y):
	var tile = single_tile_scene.instance()
	tile.position = Vector2(x, y)
	tile.name = "Tile"
	self.add_child(tile)

func _ready():
	for x in range(0, 10):
		for y in range(0, 10):
			_add_tile_at(x * tile_width, y * tile_width)
