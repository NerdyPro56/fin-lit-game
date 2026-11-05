extends Node2D
@onready var textbox: CanvasLayer = $Textbox
var cutscene = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.queue_text("Welcome back!")
	textbox.queue_text("Oh! You've gotten me a flower for monster protection? Thanks so much!")
	textbox.queue_text("Here, take this key! I'm not sure where it leads but surly you'll make good use of it!")
	textbox.queue_text("This one's on me but if you'd like to loan any transportation or items please let me know!")
	textbox.queue_text("For the boat and horse, the number is the down payment.")
	textbox.queue_text("Once, you have enough for the down payment. I will explain the loan terms.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene:
		$ShopHandler2.visible = false
	else:
		$ShopHandler2.visible = true
	if textbox.text_queue == []:
		cutscene = false
