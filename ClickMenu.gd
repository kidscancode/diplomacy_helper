extends PopupMenu

signal new_unit_menu

func _ready():
	add_item("New Unit", 1)

func _on_AddUnitMenu_id_pressed(ID):
	match ID:
		1:
			emit_signal("new_unit_menu")
