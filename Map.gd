extends TextureRect

enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}

var starting_regions = {CONSTANTS.NATIONS.AUSTRIA: ["VIE", "BUD", "TRI"],
						CONSTANTS.NATIONS.ENGLAND: ["LON", "EDI", "LVR"],
						CONSTANTS.NATIONS.FRANCE: ["PAR", "MAR", "BRE"],
						CONSTANTS.NATIONS.GERMANY: ["BER", "MUN", "KIE"],
						CONSTANTS.NATIONS.ITALY: ["ROM", "VEN", "NAP"],
						CONSTANTS.NATIONS.RUSSIA: ["MOS", "SEV", "STP", "WAR"],
						CONSTANTS.NATIONS.TURKEY: ["ANK", "CON", "SMY"]}
						
onready var Piece = preload("res://Piece.tscn")
onready var select_menu = $CanvasLayer/OrderSelectMenu
var selected = null
var select_target = false
var new_pos = null

func _ready():
	var img = texture.get_data()
	img.lock()
	for piece in $Pieces.get_children():
		piece.connect("clicked", self, "_on_Piece_clicked")
	set_start_owners()

func set_start_owners():
	for nation in starting_regions:
		for reg in starting_regions[nation]:
			#print("setting", reg, "to", CONSTANTS.AUSTRIA)
			get_node("Regions").get_node(reg).control = nation
		
func _unhandled_input(event):
	if event.is_action_pressed('ui_select'):
		# clear all orders
		for piece in $Pieces.get_children():
			piece.move = NONE
			selected = null
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if select_target:
				selected.target = get_global_mouse_position()
				select_target = false
				selected.active = false
				selected = null
		if event.button_index == BUTTON_MIDDLE:
				new_pos = get_global_mouse_position()
				$CanvasLayer/ClickMenu.rect_position = $CanvasLayer/ClickMenu.get_global_mouse_position()
				$CanvasLayer/ClickMenu.popup()

				

func _on_Piece_clicked(piece):
	if piece.active:
		if selected:
			selected.active = false
		selected = piece
		select_menu.rect_position = select_menu.get_global_mouse_position()
		printt(get_global_mouse_position(), $Camera2D.position)
		select_menu.set_item_disabled(CONVOY, selected.type == selected.TYPES.ARMY)
		select_menu.popup()
	else:
		selected = null

func _on_OrderSelectMenu_id_pressed(ID):
	selected.move = ID
	selected.target = null
	match ID:
		NONE:
			selected.active = false
			selected = null
		HOLD:
			selected.active = false
			selected = null
		MOVE:
			select_target = true
		SUPPORT:
			select_target = true
		DISBAND:
			selected.queue_free()
			selected = null

func _on_ClickMenu_new_unit_menu():
	$CanvasLayer/AddUnitWindow.popup_centered()
	$CanvasLayer/AddUnitWindow.focus_mode = FOCUS_ALL

func _on_AddUnitWindow_add_unit(_nation, _type):
	printt("adding new:", _nation, _type)
	var p = Piece.instance()
	
	p.position = new_pos
	p.nation = _nation
	p.type = _type
	$Pieces.add_child(p)
	p.connect("clicked", self, "_on_Piece_clicked")
