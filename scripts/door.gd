extends Area2D

@onready var area_2d: Area2D = $Area2D
@onready var tile_0087: Sprite2D = $Tile0087
@export var sceneName: String
var inside = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inside and Input.is_action_just_pressed("text"):
		#switch scenes
		get_tree().change_scene_to_file(sceneName)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if (body.name == "player"):
		print("Area entered")
		tile_0087.visible = true
		inside = true
		
		

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if (body.name == "player"):
		tile_0087.visible = false
		inside = false
