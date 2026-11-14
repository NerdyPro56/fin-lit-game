extends Node2D

signal upgradeToPlayer(value);
signal playerPays(cost);
signal debugGiveMoney;
var debt = Global.boatDebt
#@onready var character := get_tree().root.get_node("Main").get_node("PlayerCharacter");
@onready var costNodes := $TestShopUI/Cost
var cutscene = false
const priceIncrease := 20;
@onready var textbox: CanvasLayer = $"../Textbox"
var deposit = false
var withdraw = false
func _process(delta: float) -> void:
	if ((Global.money + Global.invested) < 0):
		debt += abs(Global.money + Global.invested)
	$TestShopUI/amountlabel.text = "Current amount in bank: " + str(Global.invested)
	$TestShopUI/amountlabel2.text = "Current amount in pocket: " + str(Global.money)
	$TestShopUI/loanamount.text = "Amount owed: " + str(debt)
	
func _on_deposit_pressed() -> void:
	if !cutscene:
		deposit = true
		textbox.queue_text("How much money would you like to deposit?")
		cutscene = true
		$TestShopUI/LineEdit2.visible = true
		$TestShopUI/Button.visible = true
func _on_withdraw_pressed() -> void:
	if !cutscene:
		withdraw = true
		textbox.queue_text("How much money would you like to withdraw?")
		cutscene = true
		$TestShopUI/LineEdit2.visible = true
		$TestShopUI/Button.visible = true
		
		
func _on_button_pressed() -> void:
	var mon = int($TestShopUI/LineEdit2.text)
	if cutscene:
		cutscene = false
		if deposit:
			if mon > Global.money:
				textbox.queue_text("Please enter a valid amount!")
				cutscene = true
				return
			deposit = false
			Global.invested += int($TestShopUI/LineEdit2.text)
			Global.money -= int($TestShopUI/LineEdit2.text)
			textbox.queue_text($TestShopUI/LineEdit2.text + " coins have been deposited into your account!")
		if withdraw:
			if mon > Global.invested:
				textbox.queue_text("Please enter a valid amount!")
				cutscene = true
				return
			withdraw = false
			Global.invested -= mon
			Global.money += mon
			textbox.queue_text($TestShopUI/LineEdit2.text + " coins have been withdrawn from your account!")
		$TestShopUI/LineEdit2.visible = false
		$TestShopUI/Button.visible = false
#Shop Button singals
#it has to have a upgrade index and be in the cost array
#func _on_health_pressed() -> void:
	#var upgradeIndex := 0;
	#$TestShopUI/Purchases/boat.hide()
	#$TestShopUI/Cost/boat.hide()
	#if canPurchase(upgradeIndex):
		#sendToPlayer("health");
	#
#func _on_damage_pressed() -> void:
	#$TestShopUI/Purchases/carriage.hide()
	#$TestShopUI/Cost/carriage.hide()
	#var upgradeIndex := 1;
	#if canPurchase(upgradeIndex):
		#sendToPlayer("damage")
#
#func _on_speed_pressed() -> void:
	#$TestShopUI/Purchases/fruits.hide()
	#$TestShopUI/Cost/fruits.hide()
	#var upgradeIndex := 2;
	#if canPurchase(upgradeIndex):
		#sendToPlayer("speed");

#checks if the player can afford the upgrade
#if so it emits a signal to the player and it pays the amount
#calls the update func
#func canPurchase(index):
	#if Global.money >= cost[index]:
		#playerPays.emit(cost[index]);
		#update(index);
		#return true;
	#else:
		#return false;

#increases the price of an item after it's purchased
#cycles through all neccesary labels and set's text to new cost amt
#func update(index):
	##cost[index] += priceIncrease;
	##
	##var i = 0;
	##for child in costNodes.get_children():
		##child.text = str(cost[i]);
		##i+=1;

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
	Global.xTownPos = 2
	Global.yTownPos = -148
	get_tree().change_scene_to_file("res://scenes/town.tscn")
