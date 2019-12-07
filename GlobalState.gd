extends Node

signal score_changed
signal speed_increased

var lines_cleared = 0
var speed = 1

func _calculate_speed_for_lines_cleared(lines_cleared):
  if lines_cleared < 10:
    return 1
  elif lines_cleared < 25:
    return 2
  elif lines_cleared < 50:
    return 3
  elif lines_cleared < 75:
    return 4
  elif lines_cleared < 100:
    return 6
  elif lines_cleared < 300:
    return 8
  else:
    return 10

func on_line_cleared():
  lines_cleared += 1
  emit_signal("score_changed", lines_cleared)

  if speed != _calculate_speed_for_lines_cleared(lines_cleared):
    speed = _calculate_speed_for_lines_cleared(lines_cleared)
    emit_signal("speed_increased")

func reset():
  lines_cleared = 0
  speed = 1
  emit_signal("score_changed", lines_cleared)
  emit_signal("speed_increased")

func _ready():
  var err = get_tree().root.connect("size_changed", self, "_on_resize")
  assert(err == OK)

func _on_resize():
  # Enfore 1:1 aspect ratio
  if OS.window_size.x > OS.window_size.y:
    OS.window_size.y = OS.window_size.x
  else:
    OS.window_size.x = OS.window_size.y

func format_speed_label():
  if speed == 10:
    return "1000% (MAX)"
  else:
    return "%3d%%" % (speed * 100)

func forced_movement_delay():
  return 1.0 / speed

func forced_placement_delay():
  return max((1.0 / speed) * 6, 2.5)

func key_delay_time(direction):
  return min(forced_movement_delay(), 0.2)
