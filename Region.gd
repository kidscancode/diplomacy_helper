extends Sprite

var control setget change_control

func _ready():
	self.control = -1
	self.modulate.a = 0.4
	
func change_control(_control):
	control = _control
	if control >= 0:
		self_modulate = CONSTANTS.COLORS[control]
	else:
		self_modulate = Color(1, 1, 1)

func update():
	var p = $Area2D.get_overlapping_areas()
	for u in p:
		self.control = u.get_parent().nation