extends Node2D
@onready var player: CharacterBody2D = $player
@onready var textbox: CanvasLayer = $Textbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.botlim = 100
	textbox.queue_text("meow")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_3_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
