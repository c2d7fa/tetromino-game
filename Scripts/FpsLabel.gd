extends Label

func _process(delta):
  if delta != 0:
    text = "%.1f FPS" % (1 / delta)
