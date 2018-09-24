extends Camera2D

var zoom_level = 1.0 setget set_zoom

func _ready():
	zoom = Vector2(1, 1)
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom_level -= 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom_level += 0.1

func set_zoom(_zoom):
	position += get_local_mouse_position()
	zoom_level = _zoom
	zoom_level = clamp(zoom_level, 0.3, 1.0)
	zoom = Vector2(1, 1) * zoom_level			