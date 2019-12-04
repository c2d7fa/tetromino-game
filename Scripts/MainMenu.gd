extends Panel

const MainScene = preload("res://Scenes/MainScene.tscn")

func _input(ev):
  if ev.is_action_pressed("start"):
    get_tree().change_scene_to(MainScene)
