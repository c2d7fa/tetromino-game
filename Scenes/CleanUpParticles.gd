extends Particles2D

var _timer

func _ready():
  one_shot = true
  _timer = Timer.new()
  var err = _timer.connect("timeout", self, "on_timeout")
  assert(err == OK)
  _timer.set_wait_time(lifetime)
  add_child(_timer)
  _timer.start()

func on_timeout():
  get_parent().remove_child(self)
