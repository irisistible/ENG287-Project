# Draggable.gd
extends Node2D

var draggable := false
var offset: Vector2
var current_slot = null
var index: int
var category: int

func _ready() -> void:
	add_to_group("draggable")

func init(p_index: int, p_category: int, p_texture: Texture2D, p_slot) -> void:
	index = p_index
	category = p_category
	get_node("Sprite2D").texture = p_texture
	global_position = p_slot.global_position
	place_in_slot(p_slot)

func place_in_slot(slot) -> void:
	current_slot = slot
	slot.set_occupant(self)

func _process(_delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			_on_released()

func _on_released() -> void:
	var best_slot = null
	var best_dist := INF
	for slot in get_tree().get_nodes_in_group("slot"):
		if slot.category != category:
			continue
		var d = global_position.distance_to(slot.global_position)
		if d < best_dist:
			best_dist = d
			best_slot = slot

	var tween = get_tree().create_tween()

	if best_slot != null and best_dist < 60.0:
		if best_slot == current_slot:
			tween.tween_property(self, "global_position", current_slot.global_position, 0.2).set_ease(Tween.EASE_OUT)
		elif best_slot.occupant == null:
			current_slot.set_occupant(null)
			best_slot.set_occupant(self)
			current_slot = best_slot
			tween.tween_property(self, "global_position", current_slot.global_position, 0.2).set_ease(Tween.EASE_OUT)
		else:
			var other = best_slot.occupant
			var my_old_slot = current_slot
			my_old_slot.set_occupant(other)
			best_slot.set_occupant(self)
			other.current_slot = my_old_slot
			current_slot = best_slot
			tween.tween_property(self, "global_position", current_slot.global_position, 0.2).set_ease(Tween.EASE_OUT)
			get_tree().create_tween().tween_property(other, "global_position", other.current_slot.global_position, 0.2).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "global_position", current_slot.global_position, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
		
func _on_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group("slot") and category == body.category:
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		
func _on_area_2d_body_exited(body):
	if body.is_in_group("slot") and category == body.category:
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
