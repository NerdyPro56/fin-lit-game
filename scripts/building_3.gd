extends Node2D
@onready var textbox: CanvasLayer = $Textbox
var cutscene = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.blackFirst:
		Global.blackFirst = false
		textbox.queue_text("Welcome back!")
		textbox.queue_text("Oh! Got me a flower to protect against those nasty monsters? Appreciate it!")
		textbox.queue_text("Oh? This key? You want it? Well you gotta pay for it!")
		textbox.queue_text("There's no way I would've given it to you for free just cause of a stupid flower!")
	else:
		textbox.queue_text("Welcome back! Whatchu lookin for kid?")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene:
		$ShopHandler.visible = false
	else:
		$ShopHandler.visible = true
	if textbox.text_queue == []:
		cutscene = false
