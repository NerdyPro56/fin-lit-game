extends CharacterBody2D

var SPEED = 50

@onready var attack_timer = $AttackTimer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hurty: Timer = $hurty
var ouch = false
@onready var _07_human_atk_sword_2: AudioStreamPlayer = $"07HumanAtkSword2"
var e = true
@onready var player = null
var randomnum
var health = 40
var dead = false
@onready var die: Timer = $die
@export var dmg: int = 8
enum {
	SURROUND,
	ATTACK,
	HIT,
}

var state = SURROUND
var velocitye = Vector2.ZERO
var knockback = Vector2.ZERO
var knockback_timer = 0.0
func _ready():
	velocity = Vector2.ZERO
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	attack_timer.start()

	# Ensure player is assigned after the scene is ready
	player = get_parent().get_node("player")  # Update the path to your player node if necessary

func _physics_process(delta):
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta
		move_and_slide()
	elif !ouch:
		if not player:
			return  # Ensure player is set before proceeding
		if health <= 0 and !dead:
			collision_shape_2d.disabled = true
			animated_sprite_2d.play("death")
#			animated_sprite_2d.set_scale(Vector2(1.4, 1.4))
			dead = true
			die.start()
			return
		if !dead:
			match state:
				SURROUND:
					move(get_circle_position(randomnum), delta)
					
				ATTACK:
					move(player.global_position, delta)
					if (global_position - player.global_position).length() < 22:  # Adjust the distance threshold as needed
						state = HIT
				HIT:
					perform_attack()
					state = SURROUND
					randomnum = randf()

func move(target, delta):
	if (global_position - player.global_position).length() < 150:
		animated_sprite_2d.play("chase")
		var direction = (target - global_position).normalized()
		var desired_velocity = direction * SPEED
		var steering = (desired_velocity - velocity) * delta * 2.5
		velocity += steering
		if velocity.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		move_and_slide()  # Call the function with the velocity argument
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40  # Distance from center to circumference of circle
	var angle = random * PI * 2
	var x = kill_circle_centre.x + cos(angle) * radius
	var y = kill_circle_centre.y + sin(angle) * radius

	return Vector2(x, y)
func apply_knockback(source_position: Vector2, strength: float = 150.0):
	var direction = (global_position - source_position).normalized()
	knockback = direction * strength
	knockback_timer = 0.2 # lasts 0.2 seconds
func perform_attack():
	print("HIT")
	animated_sprite_2d.play("attack")
	ouch = true
	hurty.start()
	print("OUCHIE")
	player.hurt_player(dmg, self)

func _on_AttackTimer_timeout():
	state = ATTACK
func hurt(x):
	print("ow")
	self.apply_knockback(player.global_position)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0, 0), 0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0, 0), 0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0, 0), 0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.1)	
	health -= x
	ouch = true
	_07_human_atk_sword_2.play()
	hurty.start()

func _on_hurty_timeout() -> void:
	ouch = false
	hurty.stop()


func _on_die_timeout() -> void:
	animated_sprite_2d.visible = false
	queue_free()
	die.stop()
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player":
		state = HIT
