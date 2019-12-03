extends Node2D

func _input(event):
  if event.is_pressed():
    assert(get_tree().change_scene("res://Scenes/MainScene.tscn") == OK)

func _ready():
  $FinalScoreLabel.text = "Lines cleared: %s" % GlobalState.lines_cleared