extends Panel

func _input(event):
  if event.is_action_pressed("start"):
    assert(get_tree().change_scene("res://Scenes/MainScene.tscn") == OK)

func _ready():
  $VBoxContainer/FinalScoreLabel.text = "Lines cleared: %s" % GlobalState.lines_cleared
