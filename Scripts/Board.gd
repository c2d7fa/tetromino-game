extends Node2D

const BackgroundTile = preload("res://Scenes/BackgroundTile.tscn")
const SingleTileGrey = preload("res://Scenes/SingleTileGrey.tscn")

const tile_width = 48

const width = 10
const height = 18

func place_piece(piece):
  for offset in piece.get_filled_offsets():
    _fill_tile(piece.x + offset[0], piece.y + offset[1], piece.color())

func _fill_tile(x, y, color):
  var tile = SingleTileGrey.instance()
  tile.position.x = x * tile_width
  tile.position.y = y * tile_width
  tile.modulate.r8 = color[0]
  tile.modulate.g8 = color[1]
  tile.modulate.b8 = color[2]
  add_child(tile)

func _ready():
  for c in width:
    for r in height:
      var tile = BackgroundTile.instance()
      tile.position.x = c * tile_width
      tile.position.y = r * tile_width
      add_child(tile)
