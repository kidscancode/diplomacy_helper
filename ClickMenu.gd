extends PopupMenu

signal save_state
signal load_state
signal new_unit_menu
signal update_regions

func _ready():
	add_item("New Unit", 1)
	add_item("Update Regions", 2)
	add_item("Save State", 3)
	add_item("Load State", 4)

func _on_AddUnitMenu_id_pressed(ID):
	match ID:
		1:
			emit_signal("new_unit_menu")
		2:
			emit_signal("update_regions")
		3:
			emit_signal("save_state")
		4:
			emit_signal("load_state")