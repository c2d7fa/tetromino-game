extends Node2D

func _input(event):
  if event.is_pressed():
    get_tree().change_scene("res://Scenes/MainScene.tscn")

func _ready():
  $FinalScoreLabel.text = "Lines cleared: %s" % GlobalState.lines_cleared