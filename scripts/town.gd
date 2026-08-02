extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var tile_0087: Sprite2D = $Area2D/Tile0087
@onready var player: CharacterBody2D = $player
var inside = false
@onready var ilikecats: Sprite2D = $Area2D4/ilikecats
@onready var textbox: CanvasLayer = $Textbox
var done1 = false
@onready var line_edit_2: LineEdit = $Textbox/LineEdit2
var result1
var done2 = false
var done3 =  false
var cave = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.set_position(Vector2(Global.xTownPos, Global.yTownPos))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inside and Input.is_action_just_pressed("text"):
		#switch scenes
		if textbox.text_queue.size() == 0 and textbox.current_text == "":
			textbox.queue_text("'(Sorry for the big sign!) This sign is pointed towards the wilderness. Enter at your own risk!'")
	if textbox.text_queue.size() == 0 and done1 and !done2:
		done2 = true
		$Textbox/LineEdit2.visible = true
		$Textbox/Button.visible = true
	if done1 and done2 and $Textbox/Button.visible == false and !done3:
		done3 = true
		cave = true
		if result1:
			textbox.queue_text("GOOD JOB! I'll give you 100 coins for that correct answer. Now go out there (to your left) and slay those monsters! I'll pay you when you get back")
		else:
			textbox.queue_text("WRONG! It's 2000 gold for 40 hours! Now go out there (to your left) and slay those monsters! I'll pay you when you get back")
		Global.employed = true
		$player.cutscene = false
func _on_area_2d_4_body_entered(body: CharacterBody2D) -> void:
	if (body.name == "player"):
		print("Area entered")
		ilikecats.visible = true
		inside = true


func _on_area_2d_4_body_exited(body: CharacterBody2D) -> void:
	if (body.name == "player"):
		ilikecats.visible = false
		inside = false


func _on_area_2d_5_body_entered(body: CharacterBody2D) -> void:
	if (body.name == "player") and !done1 and !Global.employed:
		body.cutscene = true
		done1 = true
		textbox.queue_text("OI! I'M OVER HERE! IN THE STAND! CAN'T YOU SEE ME?! I'M NOT SHORT ALRIGHT?!")
		textbox.queue_text("So... You short on money or something kid?")
		textbox.queue_text("Yes? Well you seem nice enough to be a good wage sla- I mean employee! I need someone to cleanup for my miners!")
		textbox.queue_text("Let's say each monster takes you 2 hours to kill (I'm being generous here). And each hour I pay you 50")
		textbox.queue_text("If I commissioned you to kill 20 monsters, how much am I paying you?")
		
func check_answer(txt, correct_answer):
	var answer = txt
	if answer == correct_answer:
		return true
	else:
		return false
	line_edit_2.clear()


func _on_button_pressed() -> void:
	result1 = check_answer(line_edit_2.text, "2000")
	$Textbox/LineEdit2.visible = false
	$Textbox/Button.visible = false
	print(result1)


func _on_area_2d_6_body_entered(body: CharacterBody2D) -> void:
	if Global.employed and body.name == "player":
		print("Changing to Mines")
		get_tree().change_scene_to_file("res://scenes/mines.tscn")
	elif textbox.text_queue.size() == 0 and textbox.current_text == "" and body.name == "player":
		textbox.queue_text("I don't think I need to go to the mines right now. There's not really any reason to... Unless I get a job???")


func _on_area_2d_7_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player" and Global.employed:
		print("Changing to Wilderness")
		get_tree().change_scene_to_file("res://scenes/wilderness.tscn")
	elif body.name == "player" and !Global.employed and textbox.text_queue.size() == 0 and textbox.current_text == "":
		textbox.queue_text("I should seek employment (get a job first you bum)")
	
