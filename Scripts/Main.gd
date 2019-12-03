extends Node2D

const Piece = preload("res://Scripts/Piece.gd")
const GameOverScene = preload("res://Scenes/GameOverScene.tscn")
const Bag = preload("res://Classes/Bag.gd")

var piece: Piece

var bag = Bag.new()

func lose():
  assert(get_tree().change_scene_to(GameOverScene) == OK)

func _new_piece():
  piece = Piece.new(bag.draw(), $Board, self, $MoveTimer)
  assert(piece.connect("placement", self, "_on_placement") == OK)
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

func on_row_cleared(r):
  GlobalState.on_line_cleared()
  $ScoreBounce.stop()
  $ScoreBounce.play("ScoreBounce")
  $ScreenShake.stop()
  $ScreenShake.play("ScreenShake")

func _ready():
  assert($Board.connect("row_cleared", self, "on_row_cleared") == OK)
  assert(GlobalState.connect("score_changed", $UI/ScoreLabel, "on_score_changed") == OK)
  GlobalState.reset()
  randomize()
  _new_piece()

func _on_Board_row_cleared():
  pass # Replace with function body.
