extends Node2D

signal upgradeToPlayer(value);
signal playerPays(cost);
signal debugGiveMoney;

#@onready var character := get_tree().root.get_node("Main").get_node("PlayerCharacter");
@onready var costNodes := $TestShopUI/Cost
var cutscene = true
const priceIncrease := 20;

var cost := [500,200,20] #index 0 = health / index 1 = damage / index 2 = speed

#Shop Button singals
#it has to have a upgrade index and be in the cost array
func _on_health_pressed() -> void:
	var upgradeIndex := 0;
	
	if canPurchase(upgradeIndex):
		sendToPlayer("health");

func _on_damage_pressed() -> void:
	var upgradeIndex := 1;
	if canPurchase(upgradeIndex):
		sendToPlayer("damage")

func _on_speed_pressed() -> void:
	var upgradeIndex := 2;
	if canPurchase(upgradeIndex):
		sendToPlayer("speed");

#checks if the player can afford the upgrade
#if so it emits a signal to the player and it pays the amount
#calls the update func
func canPurchase(index):
	if Global.money >= cost[index]:
		playerPays.emit(cost[index]);
		update(index);
		return true;
	else:
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
