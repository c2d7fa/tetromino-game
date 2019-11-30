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

var _piece_type
var _color
var _board

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

func _top_offset():
  var min_y = INF
  for offset in get_filled_offsets():
    if offset[1] < min_y:
      min_y = offset[1]
  return min_y

func get_width():
  var max_x = 0
  for offset in get_filled_offsets():
    if offset[0] > max_x:
      max_x = offset[0]
  return max_x + 1 - _left_offset()

func get_height():
  var max_y = 0
  for offset in get_filled_offsets():
    if offset[1] > max_y:
      max_y = offset[1]
  return max_y + 1 - _top_offset()

func get_real_tile_positions():
  var result = []
  for offset in get_filled_offsets():
    result += [[offset[0] + x, offset[1] + y]]
  return result

func get_real_x():
  var real_x = INF
  for pos in get_real_tile_positions():
    if pos[0] < real_x:
      real_x = pos[0]
  return real_x

func get_real_y():
  var real_y = INF
  for pos in get_real_tile_positions():
    if pos[1] < real_y:
      real_y = pos[1]
  return real_y

func color():
  return _color

func _init(piece_type, board, main):
  _piece_type = piece_type
  _board = board
  _color = colors[piece_type]

  node = Node2D.new()
  node.name = "Piece_Type%s" % PieceType.keys()[piece_type]

  for coord in coords[piece_type]:
    _filled_tiles[coord[0]][coord[1]] = true

  x = ((board_width - 1) / 2) - _left_offset() - ((get_width() - 1) / 2)

  _update_tiles()
  _update_position()

  if _invalid_position():
    # We couldn't place piece!
    main.lose()

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

func move_down():
  var old_y = y
  y += 1
  _consider_reverting_move(x, old_y, _filled_tiles)
  _update_position()

func move_left():
  var old_x = x
  x -= 1
  _consider_reverting_move(old_x, y, _filled_tiles)
  _update_position()

func move_right():
  var old_x = x
  x += 1
  _consider_reverting_move(old_x, y, _filled_tiles)
  _update_position()

func _overlaps_board():
  for pos in get_real_tile_positions():
    if _board.is_filled(pos[0], pos[1]):
      return true
  return false

func _invalid_position():
  return get_real_x() < 0 or get_real_y() + get_height() > board_height or get_real_x() + get_width() > board_width or _overlaps_board()

func _consider_reverting_move(old_x, old_y, old_filled_tiles):
  if _invalid_position():
    # The current state puts the piece in an invalid position; revert to old position.
    x = old_x
    y = old_y
    _filled_tiles = old_filled_tiles
    _update_tiles()
    _update_position()

func rotate_counterclockwise():
  var old_filled_tiles = _filled_tiles
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
  _consider_reverting_move(x, y, old_filled_tiles)

func rotate_clockwise():
  for i in 3:
    rotate_counterclockwise()

func drop():
  while !_invalid_position():
    y += 1
    _update_position()
  y -= 1
