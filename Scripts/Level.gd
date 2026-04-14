extends Control

const DIALOGUE_SCENE = preload("res://Scenes/DialogScene.tscn")
const PUZZLE_SCENE = preload("res://Scenes/PuzzleScene.tscn")

func _ready() -> void:
	_play_dialogue()

func _play_dialogue() -> void:
	var dialogue = DIALOGUE_SCENE.instantiate()
	add_child(dialogue)
	dialogue.init(GameManager.current_level().dialog)
	dialogue.finished.connect(_on_dialogue_finished)

func _on_dialogue_finished() -> void:
	get_tree().change_scene_to_packed(PUZZLE_SCENE)
