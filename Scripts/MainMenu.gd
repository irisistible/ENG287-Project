extends Control


func _on_start_game_button_pressed() -> void:
	GameManager.current_level_index = 0
	get_tree().change_scene_to_file("res://Scenes/Level.tscn")


func _on_choose_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ChooseLevel.tscn")


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
