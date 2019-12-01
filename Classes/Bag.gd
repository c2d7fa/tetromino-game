const Piece = preload("res://Scripts/Piece.gd")

var _bag = []

func draw():
  if _bag.empty():
    _refill_bag()
  return _bag.pop_front()

func _refill_bag():
  _bag = [Piece.PieceType.I, Piece.PieceType.O, Piece.PieceType.T, Piece.PieceType.J, Piece.PieceType.L, Piece.PieceType.S, Piece.PieceType.Z]
  _bag.shuffle()
