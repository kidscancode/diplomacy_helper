extends PopupPanel

signal add_unit

onready var nations = $VBoxContainer/Nations
onready var units = $VBoxContainer/Units

var countries = {"Austria": CONSTANTS.AUSTRIA,
				 "England": CONSTANTS.ENGLAND,
				 "France": CONSTANTS.FRANCE,
				 "Germany": CONSTANTS.GERMANY,
				 "Italy": CONSTANTS.ITALY,
				 "Russia": CONSTANTS.RUSSIA,
				 "Turkey": CONSTANTS.TURKEY}
var types = {"Army": CONSTANTS.ARMY,
			 "Fleet": CONSTANTS.FLEET}

var unit_choice = null
var country_choice = null

func _ready():
	for name in countries.keys():
		nations.add_item(name)
	for name in types.keys():
		units.add_item(name)
	#popup_centered()

func _on_Button_pressed():
	emit_signal("add_unit", country_choice, unit_choice)
	hide()

func _on_Nations_item_selected(index):
	country_choice = index

func _on_Units_item_selected(index):
	unit_choice = index
	