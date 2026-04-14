# PuzzleScene.gd
class_name PuzzleScene
extends Node2D

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
		var slot_p = slot_scene.instantiate()
		slot_p.init(i, 0, true, Vector2(i * 150 + 100, 100))
		slot_p.occupant_changed.connect(_on_slot_changed)
		add_child(slot_p)

		var slot_w = slot_scene.instantiate()
		slot_w.init(i, 1, true, Vector2(i * 150 + 100, 250))
		slot_w.occupant_changed.connect(_on_slot_changed)
		add_child(slot_w)

func _spawn_presents() -> void:
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.init(i, 0, false, Vector2(i * 150 + 100, 400))
		add_child(slot)

		var draggable = draggable_scene.instantiate()
		draggable.index = i
		draggable.category = 0
		draggable.get_node("Sprite2D").texture = puzzle_data.presents[i].icon
		add_child(draggable)
		draggable.global_position = slot.global_position
		draggable.place_in_slot(slot)

func _spawn_wrappings() -> void:
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.init(i, 1, false, Vector2(i * 150 + 100, 550))
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
		label.position = Vector2(550, i * 40 + 50)
		add_child(label)

func _on_slot_changed(slot) -> void:
	if slot.occupant == null:
		puzzle.assign(slot.category, slot.index, -1)
	else:
		puzzle.assign(slot.category, slot.index, slot.occupant.index)

	if puzzle.is_solved():
		print("Puzzle solved!")
