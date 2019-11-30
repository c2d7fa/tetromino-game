extends Node2D

func _input(event):
  if event.is_pressed():
    get_tree().change_scene("res://Scenes/MainScene.tscn")
