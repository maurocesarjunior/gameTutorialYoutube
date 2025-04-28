extends MarginContainer

@onready var text_label: Label = $label_margin/text_label

const MAX_WIDTH = 256
var text = ""

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	text_label.text = text
