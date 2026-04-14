# Slot.gd
extends StaticBody2D

signal occupant_changed(slot)

var index: int
var category: int
var is_solution: bool = false
var occupant = null

func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func init(p_index: int, p_category: int, p_is_solution: bool, p_position: Vector2) -> void:
	index = p_index
	category = p_category
	is_solution = p_is_solution
	position = p_position
	add_to_group("slot")

func set_occupant(new_occupant) -> void:
	occupant = new_occupant
	emit_signal("occupant_changed", self)
	
func _process(_delta: float) -> void:
	if global.is_dragging:
		visible = true
	else:
		visible = false
