extends Node2D
@export var monster_scene: PackedScene = preload("res://scenes/monster.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#range of x values -290 to 540
	#range of y values -241 to 484
	#for i in range(20):
		#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	Global.xTownPos = -299
	Global.yTownPos = 66
	get_tree().change_scene_to_file("res://scenes/town.tscn")


func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	get_tree().change_scene_to_file("res://scenes/chestRoom1.tscn")
