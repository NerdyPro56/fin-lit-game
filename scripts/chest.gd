extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.chest1:
		play("default")
	else:
		play("d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $ilikecats.visible and Input.is_action_just_pressed("text"):
		play("default")
		$"../Textbox".queue_text("You found 500 gold!")
		Global.money += 500
		$ilikecats.visible = false
		Global.chest1 = true


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player" and !Global.chest1:
		$ilikecats.visible = true



func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.name == "player":
		$ilikecats.visible = false
