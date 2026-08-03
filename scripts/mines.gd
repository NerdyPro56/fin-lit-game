extends Node2D
@export var monster_scene: PackedScene = preload("res://scenes/monster.tscn")
var min_spawn_range = Vector2(-290, -241)
var max_spawn_range = Vector2(-241, 484)
var completed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(20):
		spawn_monster()
	#range of x values -290 to 540
	#range of y values -241 to 484
	#for i in range(20):
		#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.killed >= 20) and !completed:
		completed = true
		print("Change textbox")


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	Global.xTownPos = -299
	Global.yTownPos = 66
	get_tree().change_scene_to_file("res://scenes/town.tscn")


func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	get_tree().change_scene_to_file("res://scenes/chestRoom1.tscn")

func spawn_monster() -> void:
	var monster_instance = monster_scene.instantiate()
	
	var random_x = randf_range(-290, 540)
	var random_y = randf_range(-241, 481)
	
	monster_instance.position = Vector2(random_x, random_y)
	monster_instance.scale = Vector2(1.5, 1.5)
	add_child(monster_instance)
