extends Node2D

const BackgroundTile = preload("res://Scenes/BackgroundTile.tscn")
const SingleTileGrey = preload("res://Scenes/SingleTileGrey.tscn")

const tile_width = 48

const width = 10
const height = 18

var _filled_tiles = []

func place_piece(piece):
  for tile in piece.get_real_tile_positions():
    _fill_tile(tile[0], tile[1], piece.color())
  _try_clear()

func is_filled(x, y):
  for pos in _filled_tiles:
    if pos[0] == x and pos[1] == y:
      return true
  return false

func _fill_tile(x, y, color):
  _filled_tiles.append([x, y])
  var tile = SingleTileGrey.instance()
  tile.position.x = x * tile_width
  tile.position.y = y * tile_width
  tile.modulate.r8 = color[0]
  tile.modulate.g8 = color[1]
  tile.modulate.b8 = color[2]
  add_child(tile)

func _is_row_filled(r):
  for c in width:
    if not is_filled(c, r):
      return false
  return true

func is_background_tile(node):
  return node.name.begins_with("Background") or node.name.begins_with("@Background@")

func _clear_row(r):
  # Clear this row
  for child in get_children():
    if child.position.y == r * tile_width && !is_background_tile(child):
      remove_child(child)
  var filled_tiles = []
  for tile in _filled_tiles:
    if tile[1] != r:
      filled_tiles.append(tile)
  _filled_tiles = filled_tiles

  # Move everything above it down by one
  for child in get_children():
    if child.position.y < r * tile_width && !is_background_tile(child):
      child.position.y += tile_width
  for tile in _filled_tiles:
    if tile[1] < r:
      tile[1] += 1

func _try_clear():
  for r in height:
    if _is_row_filled(r):
      _clear_row(r)

func _ready():
  for c in width:
    for r in height:
      var tile = BackgroundTile.instance()
      tile.name = "Background"
      tile.position.x = c * tile_width
      tile.position.y = r * tile_width
      add_child(tile)
