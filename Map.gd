extends TextureRect

enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}

onready var Piece = preload("res://Piece.tscn")
onready var info_panel = $CanvasLayer/Panel/Info
onready var select_menu = $CanvasLayer/OrderSelectMenu
onready var year_selected = $CanvasLayer/Time/Year
onready var season_selected = $CanvasLayer/Time/Season
var selected = null
var select_target = false
var new_pos = null
var score = {}

func _ready():
	season_selected.add_item("Spring", 0)
	season_selected.add_item("Fall", 1)
	season_selected.select(0)
	for i in range(1901, 1910):
		year_selected.add_item(str(i), i)
	year_selected.select(0)

func add_unit(_position, _nation, _type):
	#for unit in CONSTANTS.STARTING_UNITS:
		var p = Piece.instance()
		p.position = _position
		p.nation = _nation
		p.type = _type
		$Pieces.add_child(p)
		p.connect("clicked", self, "_on_Piece_clicked")
		
func _unhandled_input(event):
	if event.is_action_pressed('ui_select'):
		# clear all orders
		for piece in $Pieces.get_children():
			piece.move = MOVES.NONE
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
		select_menu.set_item_disabled(MOVES.CONVOY, selected.type == selected.TYPES.ARMY)
		select_menu.popup()
	else:
		selected = null

func _on_OrderSelectMenu_id_pressed(ID):
	selected.move = ID
	selected.target = null
	match ID:
		MOVES.NONE:
			selected.active = false
			selected = null
		MOVES.HOLD:
			selected.active = false
			selected = null
		MOVES.MOVE:
			select_target = true
		MOVES.SUPPORT:
			select_target = true
		MOVES.CONVOY:
			select_target = true
		MOVES.DISBAND:
			selected.queue_free()
			selected = null

func _on_ClickMenu_new_unit_menu():
	$CanvasLayer/AddUnitWindow.popup_centered()
	$CanvasLayer/AddUnitWindow.focus_mode = FOCUS_ALL

func _on_AddUnitWindow_add_unit(_nation, _type):
	#printt("adding new:", _nation, _type)
	var p = Piece.instance()
	p.position = new_pos
	p.nation = _nation
	p.type = _type
	$Pieces.add_child(p)
	p.connect("clicked", self, "_on_Piece_clicked")

func load_dialog():
	$CanvasLayer/FileDialog.popup_centered()
	
func save_state():
	var save_game = File.new()
	#var fname = "user://" + $CanvasLayer/GameName.text + ".save"
	#var fname = "user://%s_%s.save" % [$CanvasLayer/GameName.text, $CanvasLayer/TextEdit.text]
	var fname = "res://saves/%s_%s_%s.save" % [$CanvasLayer/GameName.text,
										year_selected.get_selected_id(),
										season_selected.get_item_text(season_selected.get_selected_id())]
	print(fname)
	#if save_game.file_exists("user://savegame.save"):
	save_game.open(fname, File.WRITE)	
	for unit in $Pieces.get_children():
		var d = {}
		d["data"] = "unit"
		d["posx"] = unit.position.x
		d["posy"] = unit.position.y
		d["nation"] = unit.nation
		d["type"] = unit.type
		save_game.store_line(to_json(d))
	# also regions
	for region in $Regions.get_children():
		var d = {}
		d["data"] = "region"
		d["region"] = region.name
		d["owner"] = region.control
		save_game.store_line(to_json(d))
	# and score
	var d = {"data": "score"}
	d["score"] = score
	save_game.store_line(to_json(d))
	# and status
	d = {}
	d["data"] = "time"
	d["year"] = year_selected.selected
	d["season"] = season_selected.selected
	d["gamename"] = $CanvasLayer/GameName.text
	save_game.store_line(to_json(d))
	save_game.close()
	
func load_state(fname):
	var save_game = File.new()
#	if not save_game.file_exists("user://savegame.save"):
#		print("No save found!")
#		return
	# clear existing state
	for unit in $Pieces.get_children():
		unit.queue_free()
	yield(get_tree(), "idle_frame")
	print("empty", $Pieces.get_child_count())
	
	save_game.open(fname, File.READ)
	var count = 0
	while not save_game.eof_reached():
		var line = parse_json(save_game.get_line())
		if line:
			if line["data"] == "time":
				year_selected.selected = int(line["year"])
				season_selected.selected = int(line["season"])
				$CanvasLayer/GameName.text = line["gamename"]
			if line["data"] == "score":
				var s = line["score"]
				for n in s.keys():
					score[n] = s[n]
					info_panel.get_node(str(n)).get_node("Num").text = str(score[n])
			if line["data"] == "region":
				get_node("Regions").get_node(line["region"]).control = int(line["owner"])
			if line["data"] == "unit":
				count += 1
				var pos = Vector2(line["posx"], line["posy"])
				add_unit(pos, int(line["nation"]), int(line["type"])) 
				printt("adding unit:", line["nation"], line["posx"], line["posy"])
	printt(count, $Pieces.get_child_count())
	
func _on_ClickMenu_update_regions():
	for region in $Regions.get_children():
		region.update()
	score = {CONSTANTS.NATIONS.AUSTRIA: 0, CONSTANTS.NATIONS.ENGLAND: 0,
			 	CONSTANTS.NATIONS.FRANCE: 0, CONSTANTS.NATIONS.GERMANY: 0,
			 	CONSTANTS.NATIONS.ITALY: 0, CONSTANTS.NATIONS.RUSSIA: 0,
			 	CONSTANTS.NATIONS.TURKEY: 0}
	# count score
	for sup in CONSTANTS.SUPPLY_CENTERS:
		var val = $Regions.get_node(sup).control
		if val >= 0:
			score[val] += 1
	for n in score.keys():
		info_panel.get_node(str(n)).get_node("Num").text = str(score[n])

func _on_Year_item_selected(ID):
	printt(ID, year_selected.selected, year_selected.get_selected_id(), year_selected.get_item_id(ID), year_selected.get_item_text(ID))
	#print(year_selected.get_selected_id())


func _on_Season_item_selected(ID):
	#printt(ID, season_selected.get_selected_id(), season_selected.get_item_text(ID))
	print(season_selected.get_item_text(season_selected.get_selected_id()))

func _on_FileDialog_file_selected(path):
	load_state(path)
