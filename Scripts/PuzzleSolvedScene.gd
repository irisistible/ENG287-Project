extends Control

const LEVEL_SCENE = preload("res://Scenes/Level.tscn")
const MAIN_MENU_SCENE = preload("res://Scenes/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if GameManager.has_next_level():
		GameManager.next_level()
		#get_tree().change_scene_to_packed(LEVEL_SCENE)
		get_tree().change_scene_to_file("res://Scenes/Level.tscn")
	else:
		get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
