extends Node

var levels: Array[PuzzleData] = []
var current_level_index := 0

func _ready() -> void:
	levels = [
		#load("res://Data/Levels/Level1.tres"),
		#load("res://Data/Levels/Level2.tres"),
		load("res://Data/Levels/Level3.tres"),
	]

func current_level() -> PuzzleData:
	return levels[current_level_index]

func next_level() -> void:
	current_level_index += 1

func has_next_level() -> bool:
	return current_level_index < levels.size() - 1
