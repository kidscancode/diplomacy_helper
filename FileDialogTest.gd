extends Control

func _ready():
	$FileDialog.filters = PoolStringArray(["*.save ; Save file"])
	$FileDialog.current_dir = "res://saves"
	$FileDialog.current_path = "res://saves"
	$FileDialog.popup_centered()

func _on_FileDialog_file_selected(path):
	print(path)