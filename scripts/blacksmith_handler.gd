extends Node2D

signal upgradeToPlayer(value);
signal playerPays(cost);
signal debugGiveMoney;
@onready var line_edit_2: LineEdit = $LineEdit2

#@onready var character := get_tree().root.get_node("Main").get_node("PlayerCharacter");
@onready var costNodes := $TestShopUI/Cost
var cutscene = true
const priceIncrease := 20;
@onready var textbox: CanvasLayer = $"../Textbox"
var result1
var cost := [200,200,20] #index 0 = health / index 1 = damage / index 2 = speed
var swordQ = false
#Shop Button singals
#it has to have a upgrade index and be in the cost array
func _process(delta: float) -> void:
	$Label.text = "Amount of money in pocket: " + str(Global.money)
func _on_health_pressed() -> void:
	var upgradeIndex := 0;
	if canPurchase(upgradeIndex):
		Global.health += 20
		textbox.queue_text("Thanks for purchasing the sword!")
		textbox.queue_text("I gotta warn you though... The values of swords depreciates by 10% each year.")
		textbox.queue_text("If you try to sell it back to the shop in 2 years, how much gold will I buy it back for? (I'll give 40 gold for a correct answer)") #162
		swordQ = true
		$LineEdit2.visible = true
		$Button.visible = true
		sendToPlayer("health")
func _on_damage_pressed() -> void:
	$TestShopUI/Purchases/carriage.hide()
	$TestShopUI/Cost/carriage.hide()
	var upgradeIndex := 1;
	if canPurchase(upgradeIndex):
		sendToPlayer("damage")

func _on_speed_pressed() -> void:
	$TestShopUI/Purchases/fruits.hide()
	$TestShopUI/Cost/fruits.hide()
	var upgradeIndex := 2;
	if canPurchase(upgradeIndex):
		sendToPlayer("speed");

#checks if the player can afford the upgrade
#if so it emits a signal to the player and it pays the amount
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
		
func check_answer(txt):
	var answer = txt
	if swordQ:
		if answer == "162":
			textbox.queue_text("Correct! The new price would be 162 gold! Here is 40 gold!")
			Global.money += 40
			return true
		else:
			textbox.queue_text("Incorrect! The new price would be 162 gold")
			return false
	$LineEdit2.clear()
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
	Global.xTownPos = -142
	Global.yTownPos = 25
	get_tree().change_scene_to_file("res://scenes/town.tscn")


func _on_button_pressed() -> void:
	result1 = check_answer($LineEdit2.text)
	$LineEdit2.visible = false
	$Button.visible = false
	print(result1)
