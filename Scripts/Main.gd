extends Node2D

const Piece = preload("res://Scripts/Piece.gd")
const GameOverScene = preload("res://Scenes/GameOverScene.tscn")
const Bag = preload("res://Classes/Bag.gd")
const ClearParticles = preload("res://Scenes/ClearParticles.tscn")

const tile_width = 48

var piece: Piece
var held = null
var using_held_piece = false # Is true when we have already used held piece this turn

var bag = Bag.new()

func lose():
  var err = get_tree().change_scene_to(GameOverScene)
  assert(err == OK)

func _new_piece():
  piece = Piece.new(bag.draw(), $Board, self, $MoveTimer)
  var err = piece.connect("placement", self, "_on_placement")
  assert(err == OK)
  add_child(piece)
  $UI/SidePanel/NextPiece.show_piece_type(bag.next())

func _on_placement():
  $DropSfx.play()
  $BoardBounce.play("ScreenBounce")
  using_held_piece = false
  $Board.place_piece(piece)
  remove_child(piece)
  piece.disconnect("placement", self, "_on_placement")
  _new_piece()

func start_user_move_timer(id):
  var timer = get_node("UserMoveTimer%s" % id)
  timer.set_wait_time(GlobalState.key_delay_time(id))
  timer.start()

func stop_user_move_timer(id):
  var timer = get_node("UserMoveTimer%s" % id)
  timer.stop()

func _on_user_move_timer(id):
  match id:
    "Left":
      piece.move_left()
    "Right":
      piece.move_right()
    "Down":
      piece.move_down()

func _unhandled_key_input(event):
  if event.is_action_pressed("move_left"):
    piece.move_left()
    start_user_move_timer("Left")
  elif event.is_action_released("move_left"):
    stop_user_move_timer("Left")
  elif event.is_action_pressed("move_right"):
    piece.move_right()
    start_user_move_timer("Right")
  elif event.is_action_released("move_right"):
    stop_user_move_timer("Right")
  elif event.is_action_pressed("move_down"):
    piece.move_down()
    start_user_move_timer("Down")
  elif event.is_action_released("move_down"):
    stop_user_move_timer("Down")
  elif event.is_action_pressed("rotate_clockwise"):
    piece.rotate_clockwise()
  elif event.is_action_pressed("drop"):
    piece.drop()
  elif event.is_action_pressed("hold"):
    if using_held_piece:
      # We are already using the held piece this turn. You can't swap more than once!
      return

    if held == null:
      held = piece.get_type()
      # Replace currently held piece with new piece
      remove_child(piece)
      piece.disconnect("placement", self, "_on_placement")
      _new_piece()
    else:
      var current = piece.get_type()
      # Replace currently held piece with old held piece
      remove_child(piece)
      piece.disconnect("placement", self, "_on_placement")
      piece = Piece.new(held, $Board, self, $MoveTimer)
      var err = piece.connect("placement", self, "_on_placement")
      assert(err == OK)
      add_child(piece)
      # Update held piece
      held = current

    $UI/SidePanel/HeldPiece.show_piece_type(held)
    using_held_piece = true

func on_row_cleared(r):
  $ClearSfx.play()
  GlobalState.on_line_cleared()
  $ScoreBounce.stop()
  $ScoreBounce.play("ScoreBounce")
  $ScreenShake.stop()
  $ScreenShake.play("ScreenShake")
  var particles = ClearParticles.instance()
  add_child(particles)
  particles.position.y = tile_width * r + 0.5 * tile_width
  particles.emitting = true

func _ready():
  for id in ["Left", "Right", "Down"]:
    var timer = get_node("UserMoveTimer%s" % id)
    var err = timer.connect("timeout", self, "_on_user_move_timer", [id])
    assert(err == OK)

  var err = $Board.connect("row_cleared", self, "on_row_cleared")
  assert(err == OK)
  err = GlobalState.connect("score_changed", $UI/SidePanel/ScoreLabel, "on_score_changed")
  assert(err == OK)
  err = GlobalState.connect("speed_increased", $UI/SidePanel/SpeedLabel, "on_speed_increased")
  assert(err == OK)
  GlobalState.reset()
  randomize()
  _new_piece()
