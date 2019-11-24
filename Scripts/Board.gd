extends Node2D

const BackgroundTile = preload("res://Scenes/BackgroundTile.tscn")

const tile_width = 48

func _ready():
  for c in 10:
    for r in 18:
      var tile = BackgroundTile.instance()
      tile.position.x = c * tile_width
      tile.position.y = r * tile_width
      add_child(tile)
