extends Area2D

@onready var collision: CollisionShape2D = $collision as CollisionShape2D
@onready var spike: Sprite2D = $spike as Sprite2D

func _ready():
	collision.shape.size = spike.get_rect().size
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
