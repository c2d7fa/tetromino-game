extends Node2D

const Piece = preload("res://Classes/Piece.gd")

var piece: Piece

var piece_type = 0

func place_piece_and_make_new_random():
  $Board.place_piece(piece)
  piece_type = (piece_type + 1) % Piece.PieceType.size()
  remove_child(piece.node)
  piece = Piece.new(piece_type, $Board)
  add_child(piece.node)

func _unhandled_key_input(event):
  if event.is_action_pressed("move_left"):
    piece.move_left()
  elif event.is_action_pressed("move_right"):
    piece.move_right()
  elif event.is_action_pressed("move_down"):
    piece.move_down()
  elif event.is_action_pressed("rotate_clockwise"):
    piece.rotate_clockwise()
  elif event.pressed && event.scancode == KEY_SPACE:
    place_piece_and_make_new_random()

func _ready():
  piece = Piece.new(piece_type, $Board)
  add_child(piece.node)
  
