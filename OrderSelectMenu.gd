extends PopupMenu

#enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}

var move_texture = preload("res://assets/move.png")
var hold_texture = preload("res://assets/hold.png")
var support_texture = preload("res://assets/support.png")
var convoy_texture = preload("res://assets/convoy.png")
var disband_texture = preload("res://assets/disband.png")

func _ready():
	add_icon_item(move_texture, "Move", CONSTANTS.MOVE)
	add_icon_item(hold_texture, "Hold", CONSTANTS.HOLD)
	add_icon_item(support_texture, "Support", CONSTANTS.SUPPORT)
	add_icon_item(convoy_texture, "Convoy", CONSTANTS.CONVOY)
	add_icon_item(disband_texture, "Disband", CONSTANTS.DISBAND)
	add_item("None", CONSTANTS.NONE)
	

