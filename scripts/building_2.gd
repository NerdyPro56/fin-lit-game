extends Node2D

var cutscene = true
@onready var textbox: CanvasLayer = $Textbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.queue_text("Heya! Back already?")
	textbox.queue_text("Got me a little gift as well? How thoughtful!")
	textbox.queue_text("Let me know if you need to withdraw or deposit any money!")
	textbox.queue_text("We will offer you a high-yield savings account! Our interest rates are 5%")
	textbox.queue_text("You will gain 5% interest every time you enter or leave a building!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene:
		$ShopHandler3.visible = false
	else:
		$ShopHandler3.visible = true
	if textbox.text_queue == []:
		cutscene = false
