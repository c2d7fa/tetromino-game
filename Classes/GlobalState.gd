extends Node

signal score_changed

var lines_cleared = 0

func on_line_cleared():
  lines_cleared += 1
  emit_signal("score_changed", lines_cleared)

func reset():
  lines_cleared = 0
  emit_signal("score_changed", lines_cleared)
