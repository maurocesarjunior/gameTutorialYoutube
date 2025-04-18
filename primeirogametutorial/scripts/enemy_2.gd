extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $AnimatedSprite2D as AnimatedSprite2D
var direction := -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false
		
	velocity.x = direction * SPEED * delta 

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if texture.animation == "hurt":
		queue_free()
