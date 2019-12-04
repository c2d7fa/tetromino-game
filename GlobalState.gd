extends Node

signal score_changed

var lines_cleared = 0

func on_line_cleared():
  lines_cleared += 1
  emit_signal("score_changed", lines_cleared)

func reset():
  lines_cleared = 0
  emit_signal("score_changed", lines_cleared)

func _ready():
  get_tree().root.connect("size_changed", self, "_on_resize")

func _on_resize():
  # Enfore 1:1 aspect ratio
  if OS.window_size.x > OS.window_size.y:
    OS.window_size.y = OS.window_size.x
  else:
    OS.window_size.x = OS.window_size.y
