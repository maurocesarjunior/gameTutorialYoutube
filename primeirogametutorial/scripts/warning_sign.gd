extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	"Ola viajante",
	"Espero que esteja gostando de
	 sua hospedagem por aqui hahaha",
	"..."
]

func _ready():
	texture.hide()

func _process(delta):
	# Mostra a placa se o jogador estiver perto
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
	else:
		texture.hide()
		
		# Se o jogador sair da área, fecha o diálogo
		if DialogManager.is_message_active:
			DialogManager.close_dialog()

func _unhandled_input(event):
	# Se o jogador estiver perto e apertar "interact"
	if area_sign.get_overlapping_bodies().size() > 0 and event.is_action_pressed("interact"):
		if not DialogManager.is_message_active:
			# Começa o diálogo passando TODAS as linhas
			DialogManager.start_message(global_position, lines)
