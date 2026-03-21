extends Node2D
class_name Office

@onready var money_label:Label = %MoneyLabel

func _ready() -> void:
	Globals.money_changed.connect(_on_money_changed)
	_on_money_changed(Globals.money, Globals.money)

func _on_money_changed(_old_money:int, new_money:int):
	money_label.text = "Money: " + str(new_money)
