extends PanelContainer
class_name CatalogueItemView

var item:ItemData : set = _set_item_data

var item_name:Label
var item_portrait:TextureRect
var item_type_label:Label
var hp_label:Label
var attack_label:Label
var power_label:Label
var defense_label:Label
var purchase_button:Button

var attack:HBoxContainer
var power:HBoxContainer
var hp:HBoxContainer
var defense:HBoxContainer

var cost:int : set = _set_cost

var purchased:bool = false

func _ready() -> void:
	item_name = find_child("ItemName", true, false)
	item_portrait = find_child("ItemPortrait", true, false)
	item_type_label = find_child("ItemTypeLabel", true, false)
	hp_label = find_child("HPLabel", true, false)
	attack_label = find_child("AttackLabel", true, false)
	power_label = find_child("PowerLabel", true, false)
	defense_label = find_child("DefenseLabel", true, false)
	purchase_button = find_child("PurchaseButton", true, false)
	hp = find_child("HP", true, false)
	attack = find_child("Attack", true, false)
	power = find_child("Power", true, false)
	defense = find_child("Defense", true, false)
	
	purchase_button.pressed.connect(_on_purchase_button_pressed)
	
	Globals.money_changed.connect(update_purchase_button.unbind(2))

func _set_item_data(new_data:ItemData):
	item = new_data
	
	if not is_node_ready():
		await ready
	
	item_name.text = new_data.item_name
	item_portrait.texture = new_data.item_portrait
	item_type_label.text = "Weapon" if new_data.item_type == ItemData.ItemType.Weapon else "Armor"
	
	if new_data.hp != 0:
		hp.show()
		hp_label.label_settings = hp_label.label_settings.duplicate()
		if new_data.hp > 0:
			hp_label.text = "+" + str(new_data.hp) + " HP"
		else:
			hp_label.text = str(new_data.hp) + " HP"
			hp_label.label_settings.font_color = Color.RED
	
	if new_data.attack != 0:
		attack.show()
		attack_label.label_settings = attack_label.label_settings.duplicate()
		if new_data.attack > 0:
			attack_label.text = "+" + str(new_data.attack) + " Attack"
		else:
			attack_label.text = str(new_data.attack) + " Attack"
			attack_label.label_settings.font_color = Color.RED
	
	if new_data.power != 0:
		power.show()
		power_label.label_settings = power_label.label_settings.duplicate()
		if new_data.power > 0:
			power_label.text = "+" + str(new_data.power) + " Power"
		else:
			power_label.text = str(new_data.power) + " Power"
			power_label.label_settings.font_color = Color.RED
	
	if new_data.defense != 0:
		defense.show()
		defense_label.label_settings = defense_label.label_settings.duplicate()
		if new_data.defense > 0:
			defense_label.text = "+" + str(new_data.defense) + " Defense"
		else:
			defense_label.text = str(new_data.defense) + " Defense"
			defense_label.label_settings.font_color = Color.RED

func _set_cost(new_cost:int):
	cost = new_cost
	
	if not is_node_ready():
		await ready
	
	update_purchase_button()

func update_purchase_button():
	if purchased:
		purchase_button.disabled = true
		purchase_button.text = "Purchased"
		return
	
	purchase_button.text = str(cost) + " Gold"
	
	if cost > Globals.money:
		purchase_button.disabled = true
		return
	
	purchase_button.disabled = false

func _on_purchase_button_pressed():
	if cost < Globals.money:
		Globals.money -= cost
		Globals.owned_items.append(item)
		purchased = true
		update_purchase_button()
