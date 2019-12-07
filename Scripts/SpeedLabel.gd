extends Label

func on_speed_increased():
  self.text = "Speed: %s" % GlobalState.format_speed_label()
