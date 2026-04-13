class_name PuzzleScene
extends Node2D

@export var puzzle_data: PuzzleData
@export var draggable_scene: PackedScene  # your draggable Node2D scene
@export var slot_scene: PackedScene       # your StaticBody2D slot scene

var puzzle: Puzzle

func _ready() -> void:
	puzzle = Puzzle.new(puzzle_data)
	_spawn_children()
	_spawn_presents()
	_spawn_wrappings()

func _spawn_children() -> void:
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.position = Vector2(i * 150 + 100, 100)  # lay them out however fits your game
		slot.add_to_group("child_slot")
		slot.index = i
		add_child(slot)
	for i in puzzle.n:
		var slot = slot_scene.instantiate()
		slot.position = Vector2(i * 150 + 100, 250)  # lay them out however fits your game
		slot.add_to_group("child_slot")
		slot.index = i
		add_child(slot)

func _spawn_presents() -> void:
	for i in puzzle.n:
		var draggable = draggable_scene.instantiate()
		draggable.position = Vector2(i * 150 + 100, 400)
		draggable.index = i
		draggable.category = 0  # 0 = present
		draggable.puzzle_scene = self
		add_child(draggable)

func _spawn_wrappings() -> void:
	for i in puzzle.n:
		var draggable = draggable_scene.instantiate()
		draggable.position = Vector2(i * 150 + 100, 550)
		draggable.index = i
		draggable.category = 1  # 1 = wrapping
		draggable.puzzle_scene = self
		add_child(draggable)

# Called by a draggable when it lands in a slot
func on_dropped(category: int, item_index: int, child_index: int) -> void:
	if category == 0:
		puzzle.assign_present(child_index, item_index)
	else:
		puzzle.assign_wrapping(child_index, item_index)
	
	if puzzle.is_solved():
		print("Puzzle solved!")
		
func on_removed(category: int, item_index: int, child_index: int) -> void:
	if category == 0:
		puzzle.assign_present(child_index, -1)
	else:
		puzzle.assign_wrapping(child_index, -1)
