extends Node2D

var cutscene = true
@onready var textbox: CanvasLayer = $Textbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.queue_text("Heya! Back already?")
	textbox.queue_text("Got me a little gift as well? How thoughtful")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene:
		$ShopHandler3.visible = false
	else:
		$ShopHandler3.visible = true
	if textbox.text_queue == []:
		cutscene = false
