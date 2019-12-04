extends Panel

const SingleTileGrey = preload("res://Scenes/SingleTileGrey.tscn")

const tile_width = 48

enum PieceType { I, O, T, J, L, S, Z }

const coords = {
  PieceType.I: [[0, 1], [1, 1], [2, 1], [3, 1]],
  PieceType.O: [[1, 0], [1, 1], [2, 0], [2, 1]],
  PieceType.T: [[1, 0], [0, 1], [1, 1], [2, 1]],
  PieceType.J: [[0, 0], [0, 1], [1, 1], [2, 1]],
  PieceType.L: [[2, 0], [0, 1], [1, 1], [2, 1]],
  PieceType.S: [[0, 1], [1, 1], [1, 0], [2, 0]],
  PieceType.Z: [[0, 0], [1, 0], [1, 1], [2, 1]],
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

func show_piece_type(piece_type):
  _reset_tiles()
  var color = colors[piece_type]
  for coord in coords[piece_type]:
    var tile = SingleTileGrey.instance()
    tile.position.x = tile_width * coord[0] + 16
    tile.position.y = tile_width * coord[1] + 16
    tile.modulate.r8 = color[0]
    tile.modulate.g8 = color[1]
    tile.modulate.b8 = color[2]
    $Tiles.add_child(tile)

func _reset_tiles():
  while $Tiles.get_child_count() > 0:
    $Tiles.remove_child($Tiles.get_child(0))
