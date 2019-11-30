const SingleTileGrey = preload("res://Scenes/SingleTileGrey.tscn")

const tile_width = 48

enum PieceType { I, O, T, J, L, S, Z }

var node: Node2D

var x = 0
var y = 0

const board_width = 10
const board_height = 16

const coords = {
  PieceType.I: [[1, 0], [1, 1], [1, 2], [1, 3]],
  PieceType.O: [[1, 0], [1, 1], [2, 0], [2, 1]],
  PieceType.T: [[1, 0], [1, 1], [1, 2], [2, 1]],
  PieceType.J: [[1, 0], [1, 1], [1, 2], [2, 0]],
  PieceType.L: [[1, 0], [1, 1], [1, 2], [2, 2]],
  PieceType.S: [[0, 0], [0, 1], [1, 1], [1, 2]],
  PieceType.Z: [[1, 0], [1, 1], [0, 1], [0, 2]],
}

const colors = {
  PieceType.I: [0x40, 0xFF, 0xFF],
  PieceType.O: [0xFF, 0xFF, 0x40],
  PieceType.T: [0xFF, 0x60, 0xFF],
  PieceType.J: [0x60, 0x60, 0xFF],
  PieceType.L: [0xFF, 0x80, 0x40],
  PieceType.S: [0x00, 0xFF, 0x40],
  PieceType.Z: [0xFF, 0x40, 0x40],
}

var _filled_tiles = [
  [false, false, false, false],
  [false, false, false, false],
  [false, false, false, false],
  [false, false, false, false],
]

var _piece_type = null
var _color = null

func get_filled_offsets():
  var result = []
  for c in 4:
    for r in 4:
      if _filled_tiles[c][r]:
        result.append([c, r])
  return result

func _left_offset():
  var min_x = INF
  for offset in get_filled_offsets():
    if offset[0] < min_x:
      min_x = offset[0]
  return min_x

func _piece_width():
  var max_x = 0
  for offset in get_filled_offsets():
    if offset[0] > max_x:
      max_x = offset[0]
  return max_x - _left_offset()

func color():
  return _color

func _init(piece_type):
  _piece_type = piece_type
  _color = colors[piece_type]

  node = Node2D.new()
  node.name = "Piece_Type%s" % PieceType.keys()[piece_type]

  for coord in coords[piece_type]:
    _filled_tiles[coord[0]][coord[1]] = true

  x = ((board_width - 1) / 2) - _left_offset() - (_piece_width() / 2)

  _update_tiles()
  _update_position()

func _update_tiles():
  # Clear exisitng tiles
  while node.get_child_count() > 0:
    node.remove_child(node.get_child(0))

  # Add in tiles according to filled_tiles
  for c in 4:
    for r in 4:
      if _filled_tiles[c][r]:
        var tile = SingleTileGrey.instance()
        tile.name = "Tile_%s_%s" % [c, r]
        tile.position.x = c * tile_width
        tile.position.y = r * tile_width
        tile.modulate.r8 = _color[0]
        tile.modulate.g8 = _color[1]
        tile.modulate.b8 = _color[2]
        node.add_child(tile)

func _update_position():
  node.position.x = x * tile_width
  node.position.y = y * tile_width

func move_up():
  y -= 1
  _update_position()

func move_down():
  y += 1
  _update_position()

func move_left():
  x -= 1
  _update_position()

func move_right():
  x += 1
  _update_position()

func rotate_counterclockwise():
  var new_filled_tiles = [[false, false, false, false], [false, false, false, false], [false, false, false, false], [false, false, false, false]]   # Yikes!

  if _piece_type == PieceType.O:
    new_filled_tiles = _filled_tiles
  elif _piece_type == PieceType.I:
    for c in 4:
      for r in 4:
        new_filled_tiles[c][r] = _filled_tiles[3 - r][c]
  else:
    for c in 3:
      for r in 3:
        new_filled_tiles[c][r] = _filled_tiles[2 - r][c]

  _filled_tiles = new_filled_tiles
  _update_tiles()

func rotate_clockwise():
  for i in 3:
    rotate_counterclockwise()
