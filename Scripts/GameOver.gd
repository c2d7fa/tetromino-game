extends Panel

func _input(event):
  if event.is_action_pressed("start"):
    var err = get_tree().change_scene("res://Scenes/MainScene.tscn")
    assert(err)

func _ready():
  $VBoxContainer/FinalScoreLabel.text = "Lines cleared: %s" % GlobalState.lines_cleared
