extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_1_time: Timer = $attack1time
@onready var camera_2d: Camera2D = $Camera2D
var botlim = 10000000000
var SPEED := 250.0
var animdir := 2 # animation direction
var attacking = false
func _ready() -> void:
	$startTime.start()
func _physics_process(delta: float) -> void:
	# reset velocity each frame
	velocity = Vector2.ZERO
	# movement input
	if Input.is_action_just_pressed("attack") and !attacking:
		SPEED /= 1.5
		attacking = true
		attack_1_time.start()
		match animdir:
			0: 
				animated_sprite_2d.play("attack1up")
				$attackareas/up/CollisionShape2D.disabled = false
			1:
				animated_sprite_2d.play("attack1right")
				$attackareas/right/CollisionShape2D.disabled = false
			2:
				animated_sprite_2d.play("attack1down")
				$attackareas/down/CollisionShape2D.disabled = false
			3:
				animated_sprite_2d.play("attack1left")
				$attackareas/left/CollisionShape2D.disabled = false
		
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
	if velocity.x != 0 and velocity.y != 0: #make diagnol same speed
		velocity.x /= 1.5
		velocity.y /= 1.5
	# animations
	#print(velocity.x)
	#print(velocity.y)
	if !attacking:
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


func _on_attack_1_time_timeout() -> void:
	$attackareas/down/CollisionShape2D.disabled = true
	$attackareas/up/CollisionShape2D.disabled = true
	$attackareas/right/CollisionShape2D.disabled = true
	$attackareas/left/CollisionShape2D.disabled = true
	SPEED *= 1.5
	attacking = false

func _on_start_time_timeout() -> void:
	camera_2d.limit_bottom = botlim
