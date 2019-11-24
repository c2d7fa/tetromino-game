const SingleTileGrey = preload("res://Scenes/SingleTileGrey.tscn")

const tile_width = 32

enum PieceType { I, O, T, J, L, S, Z }

var node: Node2D

var x = 0
var y = 0

const coords = {
  PieceType.I: [[0, 0], [0, 1], [0, 2], [0, 3]],
  PieceType.O: [[0, 0], [0, 1], [1, 0], [1, 1]],
  PieceType.T: [[0, 0], [0, 1], [0, 2], [1, 1]],
  PieceType.J: [[0, 0], [0, 1], [0, 2], [1, 0]],
  PieceType.L: [[0, 0], [0, 1], [0, 2], [1, 2]],
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

func _init(piece_type):
  node = Node2D.new()
  node.name = "Piece_Type%s" % PieceType.keys()[piece_type]
  var color = colors[piece_type]
  for index in range(coords[piece_type].size()):
    var coord = coords[piece_type][index]
    var tile = SingleTileGrey.instance()
    tile.name = "Tile_%s" % index
    tile.position.x = coord[0] * tile_width
    tile.position.y = coord[1] * tile_width
    tile.modulate.r8 = color[0]
    tile.modulate.g8 = color[1]
    tile.modulate.b8 = color[2]
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
