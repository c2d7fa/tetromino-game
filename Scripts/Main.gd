extends Node2D

const Piece = preload("res://Classes/Piece.gd")
const GameOverScene = preload("res://Scenes/GameOverScene.tscn")

var piece: Piece

var piece_type = 0

func lose():
  get_tree().change_scene_to(GameOverScene)

func drop_piece_and_make_new_random():
  piece.drop()
  $Board.place_piece(piece)
  piece_type = (piece_type + 1) % Piece.PieceType.size()
  remove_child(piece.node)
  piece = Piece.new(piece_type, $Board, self)
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
  elif event.is_action_pressed("drop"):
    drop_piece_and_make_new_random()

func _ready():
  piece = Piece.new(piece_type, $Board, self)
  add_child(piece.node)
  
