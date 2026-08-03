extends CharacterBody2D
@onready var player: CharacterBody2D = $"."

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_1_time: Timer = $attack1time
@onready var camera_2d: Camera2D = $Camera2D
var botlim = 10000000000
var SPEED := 250.0
var animdir := 2 # animation direction
var attacking = false
var oof = false
var maxHealth = 100
var currentHealth: int = maxHealth
@export var cutscene = false
@export var leftLim = -10000000
@export var rightLim = 10000000
@export var botLim = 10000000
@export var topLim = -10000000

@onready var stronk: Timer = $stronk
var knockback = Vector2.ZERO
var knockback_timer = 0.0
func _ready() -> void:
	$startTime.start()
	if get_tree().current_scene.name == "town":
		$Camera2D.zoom.x = 3
		$Camera2D.zoom.y = 3
		SPEED /= 1.4
		$PointLight2D.energy = 0
		animated_sprite_2d.light_mask = 1
		leftLim = -315
		topLim = -215
		rightLim = 600
	if get_tree().current_scene.name == "mines":
		rightLim = 760
		topLim = -380
		leftLim = -315
		botLim = 486
		camera_2d.limit_bottom = 486
		$PointLight2D.scale.x = 0.4
		$PointLight2D.scale.y = 0.4
		print("mines")
	else:
		$PointLight2D.scale.x = 0.25
		$PointLight2D.scale.y = 0.25
	camera_2d.limit_left = leftLim
	camera_2d.limit_right = rightLim
	camera_2d.limit_top = topLim
	camera_2d.limit_bottom = botLim
func _physics_process(delta: float) -> void:
	# reset velocity each frame
	if !cutscene:
		if knockback_timer > 0:
			velocity = knockback
			knockback_timer -= delta
		elif knockback_timer <= 0:
			velocity = Vector2.ZERO
			# movement input
			if Input.is_action_just_pressed("attack") and !attacking:
				SPEED /= 1.5
				attacking = true
				attack_1_time.start()
				match animdir:
					0: 
						animated_sprite_2d.play("attack1up")
						$up/CollisionShape2D.disabled = false
					1:
						animated_sprite_2d.play("attack1right")
						$right/CollisionShape2D.disabled = false
					2:
						animated_sprite_2d.play("attack1down")
						$down/CollisionShape2D.disabled = false
					3:
						animated_sprite_2d.play("attack1left")
						$left/CollisionShape2D.disabled = false
				
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
	$down/CollisionShape2D.disabled = true
	$up/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = true
	SPEED *= 1.5
	attacking = false

func _on_start_time_timeout() -> void:
	pass
	#camera_2d.limit_bottom = botlim
func hurt_player(damage_amount, body):
	if damage_amount<100:
		if stronk.is_stopped() and not cutscene:
			oof = true
			if currentHealth - damage_amount > 0:
				if body.has_method("ouchyouchy") and body.ouchyouchy():
					print("AHHHH")
					player.apply_knockback(body.global_position, 500)
				else:
					player.apply_knockback(body.global_position)
			if !(animated_sprite_2d.animation == "attack1" || animated_sprite_2d.animation == "attack2" || animated_sprite_2d.animation == "attack3"):
				var tween = create_tween()
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0, 0), 0.05)
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)
			else:
				var tween = create_tween()
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0, 0), 0.05)
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)
			#hurt_sound.play()
			currentHealth -= damage_amount
			print(currentHealth)
			stronk.start()
	else:
		if not cutscene:
			currentHealth -= damage_amount
func apply_knockback(source_position: Vector2, strength: float = 400.0):
	var direction = (global_position - source_position).normalized()
	knockback = direction * strength
	knockback_timer = 0.2 # lasts 0.2 seconds


func _on_stronk_timeout() -> void:
	oof = false


func _on_down_body_entered(body: CharacterBody2D) -> void:
	$down/CollisionShape2D.disabled = true
	$up/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = true
	if body.has_method("hurt"):
		body.hurt(20)


func _on_up_body_entered(body: CharacterBody2D) -> void:
	$down/CollisionShape2D.disabled = true
	$up/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = true
	if body.has_method("hurt"):
		body.hurt(20)

func _on_right_body_entered(body: CharacterBody2D) -> void:
	$down/CollisionShape2D.disabled = true
	$up/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = true
	if body.has_method("hurt"):
		body.hurt(20)

func _on_left_body_entered(body: CharacterBody2D) -> void:
	$down/CollisionShape2D.disabled = true
	$up/CollisionShape2D.disabled = true
	$right/CollisionShape2D.disabled = true
	$left/CollisionShape2D.disabled = true
	if body.has_method("hurt"):
		body.hurt(20)
