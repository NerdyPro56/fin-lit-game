extends Node2D
@onready var player: CharacterBody2D = $player
@onready var textbox: CanvasLayer = $Textbox
var leave = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.botlim = 100
	textbox.queue_text("I don't like the sound of that...")
	textbox.queue_text("I gotta get out of here but first I need to collect some Soul Lillies for the town's Monster protection")
	textbox.queue_text("WASD to move and Spacebar to attack!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if leave and textbox.text_queue.size() == 0 and textbox.current_text == "":
		get_tree().change_scene_to_file("res://scenes/town.tscn")

func _on_area_2d_3_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player" and Global.flowersCollected == 2:
		textbox.queue_text("Let's get outa here!")
		leave = true
	elif body.name == "player" and textbox.text_queue.size() == 0:
		textbox.queue_text("I'm as ready as you are to get outa here but didn't you say you wanted to collect at least 2 lillies first?")
			
