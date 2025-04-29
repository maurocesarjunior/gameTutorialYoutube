extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -350.0

var player_life := 10
var knockback_vector := Vector2.ZERO
var is_jumping := false
var is_hurted := false
var direction

@onready var ray_Right := $ray_right as RayCast2D
@onready var ray_Left := $ray_left as RayCast2D
@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $Remote as RemoteTransform2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	direction = Input.get_axis("esquerda", "direita")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()
	
	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if ray_Right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_Left.is_colliding():
		take_damage(Vector2(200, -200))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	
	if player_life > 0:
		player_life -= 1
	else:
		queue_free()
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _set_state():
	var state = "idle"
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	if is_hurted:
		state = "hurt"
	
	if animation.name != state:
		animation.play(state)


func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
		else:
			body.animation_player.play("hit")
			await get_tree().create_timer(0.3).timeout
			body.create_coin()
