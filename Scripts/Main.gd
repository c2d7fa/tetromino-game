extends Node2D

const Piece = preload("res://Classes/Piece.gd")
const GameOverScene = preload("res://Scenes/GameOverScene.tscn")
const Bag = preload("res://Classes/Bag.gd")

var piece: Piece

var piece_type = 0
var bag = Bag.new()

func lose():
  get_tree().change_scene_to(GameOverScene)

func _new_piece():
  piece = Piece.new(bag.draw(), $Board, self, $MoveTimer)
  piece.connect("placement", self, "_on_placement")
  add_child(piece)

func _on_placement():
  $Board.place_piece(piece)
  remove_child(piece)
  piece.disconnect("placement", self, "_on_placement")
  _new_piece()

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
    piece.drop()

func _ready():
  randomize()
  _new_piece()
