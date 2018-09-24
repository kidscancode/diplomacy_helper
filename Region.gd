extends Sprite

var control setget change_control

func _ready():
	self.control = -1
	
func change_control(_control):
	control = _control
	printt(name, control)
	if control >= 0:
		self_modulate = CONSTANTS.COLORS[control]
	else:
		self_modulate = Color(1, 1, 1)