extends Node

@onready var dialog_box_scene = preload("res://prefabs/dialog_box.tscn")
var message_lines: Array[String] = []
var current_line = 0
var dialog_box = null
var is_message_active = false
var dialog_box_position := Vector2.ZERO  # posição do diálogo

# Começa o diálogo
func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return

	message_lines = lines
	current_line = 0
	dialog_box_position = position
	show_text()
	is_message_active = true

# Exibe a linha de texto atual
func show_text():
	if dialog_box == null:
		dialog_box = dialog_box_scene.instantiate()
		get_tree().root.add_child(dialog_box)

	dialog_box.global_position = dialog_box_position
	dialog_box.display_text(message_lines[current_line])

# Escuta a tecla de "pular diálogo"
func _unhandled_input(event):
	if event.is_action_pressed("pular_dialogo") and is_message_active:
		current_line += 1
		if current_line >= message_lines.size():
			close_dialog()
		else:
			show_text()

# Fecha o diálogo
func close_dialog():
	if dialog_box:
		dialog_box.queue_free()
		dialog_box = null
	is_message_active = false
	current_line = 0
