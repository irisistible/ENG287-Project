# PuzzleScene.gd
class_name PuzzleScene
extends Node2D

const PUZZLE_SOLVED_SCENE = preload("res://Scenes/PuzzleSolvedScene.tscn")

@export var draggable_scene: PackedScene
@export var slot_scene: PackedScene

var puzzle: Puzzle
var puzzle_data: PuzzleData

func _ready() -> void:
	puzzle_data = GameManager.current_level()  # gets the right level's data
	puzzle = Puzzle.new(puzzle_data)
	_spawn_children()
	_spawn_presents()
	_spawn_wrappings()
	_spawn_hints()

func _spawn_children() -> void:
	for i in puzzle.n:
		var label = Label.new()
		label.text = "Child " + str(i)
		label.position = Vector2(i * 150 + 100, 10)
		add_child(label)
		
		var slot_p = slot_scene.instantiate()
		slot_p.init(i, 0, true, Vector2(i * 150 + 100, 100))
		slot_p.occupant_changed.connect(_on_slot_changed)
		add_child(slot_p)

		var slot_w = slot_scene.instantiate()
		slot_w.init(i, 1, true, Vector2(i * 150 + 100, 250))
		slot_w.occupant_changed.connect(_on_slot_changed)
		add_child(slot_w)

func _spawn_presents() -> void:
	var permutation = _generate_permutation(puzzle.n)
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.init(i, 0, false, Vector2(permutation[i] * 150 + 100, 400))
		add_child(slot)

		var draggable = draggable_scene.instantiate()
		draggable.index = i
		draggable.category = 0
		draggable.get_node("Sprite2D").texture = puzzle_data.presents[i].icon
		add_child(draggable)
		draggable.global_position = slot.global_position
		draggable.place_in_slot(slot)

func _spawn_wrappings() -> void:
	var permutation = _generate_permutation(puzzle.n)
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.init(i, 1, false, Vector2(permutation[i] * 150 + 100, 550))
		add_child(slot)

		var draggable = draggable_scene.instantiate()
		draggable.index = i
		draggable.category = 1
		draggable.get_node("Sprite2D").texture = puzzle_data.wrappings[i].icon
		add_child(draggable)
		draggable.global_position = slot.global_position
		draggable.place_in_slot(slot)

func _spawn_hints() -> void:
	for i in puzzle_data.hints.size():
		var label = Label.new()
		label.text = "• " + puzzle_data.hints[i]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		$CanvasLayer/Control/MarginContainer/VBoxContainer/HintsContainer.add_child(label)
		

func _on_slot_changed(slot) -> void:
	if slot.occupant == null:
		puzzle.assign(slot.category, slot.index, -1)
	else:
		puzzle.assign(slot.category, slot.index, slot.occupant.index)

func _generate_permutation(n: int) -> Array[int]:
	# 1. Create an array from 0 to n - 1
	var permutation: Array[int] = []
	permutation.assign(range(0, n)) 

	# 2. Randomly shuffle the elements
	permutation.shuffle()

	return permutation


func _on_check_solution_button_pressed() -> void:
	if puzzle.is_solved():
		_on_puzzle_solved()
	else:
		_on_puzzle_not_solved()
		
func _on_puzzle_solved() -> void:
	get_tree().change_scene_to_packed(PUZZLE_SOLVED_SCENE)
	
func _on_puzzle_not_solved() -> void:
	_shake_button()
	_show_incorrect()
	
func _shake_button() -> void:
	var button = $CanvasLayer/Control/MarginContainer/VBoxContainer/CheckSolutionButton
	var original_pos = button.position
	var tween = get_tree().create_tween()
	tween.tween_property(button, "position", original_pos + Vector2(10, 0), 0.05)
	tween.tween_property(button, "position", original_pos - Vector2(10, 0), 0.05)
	tween.tween_property(button, "position", original_pos + Vector2(8, 0), 0.05)
	tween.tween_property(button, "position", original_pos - Vector2(8, 0), 0.05)
	tween.tween_property(button, "position", original_pos, 0.05)

func _show_incorrect() -> void:
	var label = $CanvasLayer/Control/MarginContainer/VBoxContainer/IncorrectLabel
	label.visible = true
	await get_tree().create_timer(2.0).timeout
	label.visible = false
