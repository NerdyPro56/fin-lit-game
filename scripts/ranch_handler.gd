extends Node2D

signal upgradeToPlayer(value);
signal playerPays(cost);
signal debugGiveMoney;
@onready var textbox: CanvasLayer = $"../Textbox"
@onready var line_edit_2: LineEdit = $LineEdit2
var fruitQ = false
#@onready var character := get_tree().root.get_node("Main").get_node("PlayerCharacter");
@onready var costNodes := $TestShopUI/Cost
var cutscene = true
const priceIncrease := 20;
var result1
var boat = false
var boatQ = false
var cost := [500,200,100] #index 0 = health / index 1 = damage / index 2 = speed
func _process(delta: float) -> void:
	$Label.text = "Amount of money in pocket: " + str(Global.money)
func _ready() -> void:
	if Global.hasBoat:
		$TestShopUI/Purchases/boat.hide()
		$TestShopUI/Cost/boat.hide()
#Shop Button singals
#it has to have a upgrade index and be in the cost array
func _on_health_pressed() -> void:
	var upgradeIndex := 0;
	if canPurchase(upgradeIndex):
		$TestShopUI/Purchases/boat.hide()
		$TestShopUI/Cost/boat.hide()
		sendToPlayer("health")
		boat = true
		Global.hasBoat = true
		Global.boatDebt = 700
		textbox.queue_text("You've paid your down payment for the boat! You will need to finance a loan of 700 gold to purchase the boat.")
		textbox.queue_text("You will pay in installments of 50 gold until you pay off your loan (50 gold will be taken each time you travel or enter a shop)")
		textbox.queue_text("How many installments will it take for you to pay off your loan? (answer correctly for 30 gold)")
		$LineEdit2.visible = true
		$Button.visible = true
		boatQ = true
func _on_damage_pressed() -> void:
	var upgradeIndex := 1;
	if canPurchase(upgradeIndex):
		$TestShopUI/Purchases/carriage.hide()
		$TestShopUI/Cost/carriage.hide()
		sendToPlayer("damage")

func _on_speed_pressed() -> void:
	var upgradeIndex := 2;
	if canPurchase(upgradeIndex) and !fruitQ:
		Global.health += 20
		textbox.queue_text("Thanks! What is the sales tax rate for food and drink? (search for NJ sales tax) Answer correctly for 20 gold!")
		$LineEdit2.visible = true
		$Button.visible = true
		fruitQ = true
		sendToPlayer("speed")
func check_answer(txt):
	var answer = txt
	if fruitQ:
		fruitQ = false
		if answer == "6.625%" || answer == "6.625" || answer == "0.625":
			textbox.queue_text("Correct! The sales tax is 6.625% in NJ. Here is 20 gold!")
			Global.money += 20
			return true
		else:
			textbox.queue_text("Incorrect! The sales tax is 6.625% in NJ")
			return false
	if boatQ:
		boatQ = false
		if answer == "14":
			textbox.queue_text("Correct! You will pay 14 installments. Here is 30 gold!")
			Global.money += 30
			return true
		else:
			textbox.queue_text("Incorrect! You will pay 14 installments.")
			return false
	line_edit_2.clear()
#checks if the player can afford the upgrade
#if so it emits a signal tqueue_texto the player and it pays the amount
#calls the update func
func canPurchase(index):
	if Global.money >= cost[index]:
		playerPays.emit(cost[index]);
		Global.money -= cost[index]
		return true;
	else:
		if textbox.text_queue.size() == 0 and textbox.current_text == "":
			textbox.queue_text("You do not have enough money for this purhcase!")
		return false;

#increases the price of an item after it's purchased
#cycles through all neccesary labels and set's text to new cost amt
func update(index):
	cost[index] += priceIncrease;
	
	var i = 0;
	for child in costNodes.get_children():
		child.text = str(cost[i]);
		i+=1;

#sends upgrades to player
func sendToPlayer(upgrade):
	if upgrade == "health":
		upgradeToPlayer.emit("health");
	elif upgrade == "damage":
		upgradeToPlayer.emit("damage");
	elif upgrade == "speed":
		upgradeToPlayer.emit("speed");


#Debug buttons signals
func _on_give_money_plz_pressed() -> void:
	debugGiveMoney.emit();


func _on_return_pressed() -> void:
	Global.xTownPos = 243
	Global.yTownPos = 44
	get_tree().change_scene_to_file("res://scenes/town.tscn")


func _on_button_pressed() -> void:
	result1 = check_answer(line_edit_2.text)
	$LineEdit2.visible = false
	$Button.visible = false
	print(result1)
