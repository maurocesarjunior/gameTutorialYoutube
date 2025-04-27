extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	"Ola viajante",
	"Espero que esteja gostando de sua hospedagem por aqui hahaha",
	"...."
]

var current_line: int = 0

func _ready():
	texture.hide()

func _process(delta):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
	else:
		texture.hide()
		# Quando sair da área, fechar o diálogo
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.dialog_box = null
			DialogManager.is_message_active = false
			current_line = 0

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0 and event.is_action_pressed("interect"):
		if !DialogManager.is_message_active:
			# Começar o diálogo na primeira linha
			texture.hide()
			current_line = 0
			DialogManager.start_message(global_position, [lines[current_line]])
			DialogManager.is_message_active = true
		else:
			# Já tem diálogo ativo, avançar para a próxima linha
			current_line += 1
			if current_line < lines.size():
				# Acessa o Label corretamente para atualizar o texto
				var label = DialogManager.dialog_box.get_node("VBoxContainer/Label") # <- AJUSTA esse caminho se precisar
				if label:
					label.text = lines[current_line]
			else:
				# Se acabou as linhas, fechar
				DialogManager.dialog_box.queue_free()
				DialogManager.dialog_box = null
				DialogManager.is_message_active = false
				current_line = 0
