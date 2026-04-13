class_name Puzzle
extends RefCounted

# Data
var n: int                         	# Number of grandchildren
var current_state: Array[Array]		# The current state of the puzzle, currentState[0][i] represents 
									# the index of a present for child i and currentState[1][i] 
									# represents the index of a wrapping for child i
var puzzle_data: PuzzleData

func _init(p_puzzle_data: PuzzleData) -> void:
	puzzle_data = p_puzzle_data
	n = p_puzzle_data.num_children
	_reset_state()

func _reset_state() -> void:
	current_state = [[], []]
	for i in n:
		current_state[0].append(-1)
		current_state[1].append(-1)

func assign(category: int, child: int, index: int):
	if category == 0:
		assign_present(child, index)
	else:
		assign_wrapping(child, index)

# Assign a present to a child
func assign_present(child: int, present_index: int) -> void:
	current_state[0][child] = present_index

# Assign a wrapping to a child
func assign_wrapping(child: int, wrapping_index: int) -> void:
	current_state[1][child] = wrapping_index
	
# Check if all children have been assigned both a present and a wrapping
func is_complete() -> bool:
	for i in n:
		if current_state[0][i] == -1 or current_state[1][i] == -1:
			return false
	return true

# Check if the current state matches the solution in PuzzleData
func is_solved() -> bool:
	if not is_complete():
		return false
	for i in n:
		if current_state[0][i] != i:
			return false
		if current_state[1][i] != i:
			return false
	return true
