extends AnimatedSprite2D
var done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $ilikecats.visible and Input.is_action_just_pressed("text"):
		play("default")
		done = true
		$"../Textbox".queue_text("You found 200 gold!")
		Global.money += 200
		$ilikecats.visible = false


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player" and !done:
		$ilikecats.visible = true



func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.name == "player":
		$ilikecats.visible = false
