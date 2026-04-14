extends Control

signal finished

var dialog: Array[String] = []
var current_index := 0
var full_text := ""
var char_index := 0
var timer: Timer
var ready_to_input := false

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.03
	timer.timeout.connect(_on_timer_tick)
	add_child(timer)

func init(p_hints: Array[String]) -> void:
	dialog = p_hints
	_show_current()
	await get_tree().process_frame  # wait one frame before accepting input
	ready_to_input = true
	
func _show_current() -> void:
	full_text = dialog[current_index]
	char_index = 0
	$TextBox/MarginContainer/VBoxContainer/DialogText.text = ""
	timer.start()
	
func _on_timer_tick() -> void:
	char_index += 1
	$TextBox/MarginContainer/VBoxContainer/DialogText.text = full_text.substr(0, char_index)
	if char_index >= full_text.length():
		timer.stop()

func _input(event: InputEvent) -> void:
	if not ready_to_input:
		return
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if timer and not timer.is_stopped():
		timer.stop()
		$TextBox/MarginContainer/VBoxContainer/DialogText.text = full_text
	else:
		current_index += 1
		if current_index >= dialog.size():
			emit_signal("finished")
		else:
			_show_current()
