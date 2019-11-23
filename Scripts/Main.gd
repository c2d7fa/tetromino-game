extends Node2D

const single_tile_scene = preload("res://Scenes/SingleTileGrey.tscn")
const tile_width = 32

var tile = null
var tile_x = 0
var tile_y = 0

func _update_tile_position():
  tile.position = Vector2(tile_x * tile_width, tile_y * tile_width)

func _unhandled_key_input(event):
  if event.pressed:
    match event.scancode:
      KEY_UP:
        tile_y -= 1
      KEY_DOWN:
        tile_y += 1
      KEY_LEFT:
        tile_x -= 1
      KEY_RIGHT:
        tile_x += 1
    _update_tile_position()

func _ready():
  tile = single_tile_scene.instance()
  tile.name = "Tile"
  _update_tile_position()
  add_child(tile)
