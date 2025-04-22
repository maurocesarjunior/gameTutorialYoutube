extends CharacterBody2D

const box_pieces = preload("res://prefabs/box_pieces.tscn")

@onready var animation_player := $anim as AnimationPlayer
@export var pieces : PackedStringArray
@export var hitpoints := 3
var impulse := 200  # Aumentando o valor de impulso para maior força

# Função para gerar valores aleatórios dentro de um intervalo
func randf_range(min: float, max: float) -> float:
	return randf() * (max - min) + min

# Função para quebrar a caixa
func break_sprite():
	for i in range(pieces.size()):
		# Instancia o pedaço da caixa
		var piece_instance = box_pieces.instantiate()
		get_parent().add_child(piece_instance)

		# Configura a textura da peça com base na lista 'pieces'
		piece_instance.get_node("texture").texture = load(pieces[i])
		
		# Aplica um pequeno deslocamento aleatório em cada peça para separar
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))  # Ajustando para deslocamento menor
		piece_instance.global_position = global_position + random_offset

		# Aplica um impulso aleatório em direção a um ângulo aleatório
		var angle = randf_range(-PI, PI)
		var strength = randf_range(1500.0, 2500.0)  # Aumentando a força para dispersão mais forte
		var impulse_vector = Vector2.RIGHT.rotated(angle) * strength

		# Aplica o impulso na peça
		piece_instance.apply_impulse(Vector2.ZERO, impulse_vector)

		# Adiciona uma rotação mais intensa para mais realismo (espalhando mais)
		piece_instance.angular_velocity = randf_range(-8.0, 8.0)  # Aumentando a rotação para mais intensidade

		# Configura o modo de ativação da física para garantir que as peças não "durmam"
		piece_instance.can_sleep = false

	# Finaliza a caixa original
	queue_free()
