extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED := 300.0
var animdir := 2 # animation direction

func _physics_process(delta: float) -> void:
	# reset velocity each frame
	velocity = Vector2.ZERO

	# movement input
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
		animdir = 0
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		animdir = 2

	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		animdir = 3
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
		animdir = 1

	# animations
	if velocity == Vector2.ZERO:
		match animdir:
			0: animated_sprite_2d.play("idleup")
			1: animated_sprite_2d.play("idleright")
			2: animated_sprite_2d.play("idledown")
			3: animated_sprite_2d.play("idleleft")
	else:
		match animdir:
			0: animated_sprite_2d.play("walkup")
			1: animated_sprite_2d.play("walkright")
			2: animated_sprite_2d.play("walkdown")
			3: animated_sprite_2d.play("walkleft")

	move_and_slide()
