extends TextureButton
class_name InventoryMenu

@onready var inventory_menu:CanvasLayer = %InventoryMenu

@onready var character_select_container:HBoxContainer = %CharacterSelectContainer
@onready var character_select_template:MarginContainer = %CharacterSelectTemplate

@onready var stats_name:Label = %StatsName
@onready var stats_class:Label = %StatsClass
@onready var stats_hp:Label = %StatsHP
@onready var hp_bar:ProgressBar = %HPBar
@onready var stats_attack:Label = %StatsAttack
@onready var attack_bar:ProgressBar = %AttackBar
@onready var stats_power:Label = %StatsPower
@onready var power_bar:ProgressBar = %PowerBar
@onready var stats_defense:Label = %StatsDefense
@onready var defense_bar:ProgressBar = %DefenseBar
@onready var traits_container:VBoxContainer = %TraitsContainer

@onready var item_container:GridContainer = %ItemContainer
@onready var item_template:PanelContainer = %ItemTemplate

var character_select_buttons:Array[Button]

func _ready() -> void:
	clear_ui()

func _on_pressed() -> void:
	inventory_menu.show()
	populate_ui()

func _on_exit_button_pressed() -> void:
	inventory_menu.hide()
	clear_ui()

func clear_ui():
	for child in character_select_container.get_children():
		if child == character_select_template:
			continue
		
		child.queue_free()
	
	stats_hp.text = ""
	stats_power.text = ""
	stats_defense.text = ""
	stats_attack.text = ""
	
	stats_name.text = "None Selected"
	stats_class.text = "Class: None"
	
	for child in item_container.get_children():
		if child != item_template:
			child.queue_free()

func populate_ui():
	var selected:bool = false
	for character_data in Globals.hired_characters:
		var template = character_select_template.duplicate()
		var name_label = template.find_child("CharacterName", true, false)
		var portrait = template.find_child("Portrait", true, false)
		var button = template.find_child("Button", true, false)
		
		name_label.text = character_data.full_name
		portrait.texture = character_data.portrait
		button.pressed.connect(select_character.bind(character_data))
		button.button_group = character_select_template.find_child("Button").button_group
		
		character_select_buttons.append(button)
		character_select_container.add_child(template)
		template.show()
		
		if not selected:
			button.button_pressed = true
			select_character(character_data)
			selected = true
	
	for item in Globals.owned_items:
		var template = item_template.duplicate()
		item_container.add_child(template)
		template.show()
		template.item_data = item
		
		var sell_button:Button = template.find_child("SellButton", true, false)
		
		sell_button.text = "Sell for " + str(floori(item.purchase_price * Globals.resale_modifier))
		sell_button.pressed.connect(_on_sell_button_pressed.bind(template))
		
		#var name_label = template.find_child("NameLabel", true, false)
		#var hp_label = template.find_child("HPLabel", true, false)
		#var portrait = template.find_child("Portrait", true, false)
		#var attack_label = template.find_child("AttackLabel", true, false)
		#var power_label = template.find_child("PowerLabel", true, false)
		#var defense_label = template.find_child("DefenseLabel", true, false)
		#
		#name_label.text = item.item_name
		#
		#portrait.texture = item.item_portrait
		#
		#if item.hp != 0:
			#hp_label.show()
			#hp_label.text = "+" + str(item.hp) + " HP"
			#hp_label.label_settings = hp_label.label_settings.duplicate()
		#if item.hp < 0:
			#hp_label.text = str(item.hp) + " HP"
			#hp_label.label_settings.font_color = Color.RED
		#
		#if item.attack != 0:
			#attack_label.show()
			#attack_label.text = "+" + str(item.attack) + " Attack"
			#attack_label.label_settings = attack_label.label_settings.duplicate()
		#if item.attack < 0:
			#attack_label.text = str(item.attack) + " Attack"
			#attack_label.label_settings.font_color = Color.RED
		#
		#if item.power != 0:
			#power_label.show()
			#power_label.text = "+" + str(item.power) + " Power"
			#power_label.label_settings = power_label.label_settings.duplicate()
		#if item.power < 0:
			#power_label.text = str(item.power) + " Power"
			#power_label.label_settings.font_color = Color.RED
		#
		#if item.defense != 0:
			#defense_label.show()
			#defense_label.text = "+" + str(item.defense) + " Defense"
			#defense_label.label_settings = defense_label.label_settings.duplicate()
		#if item.defense < 0:
			#defense_label.text = str(item.defense) + " Defense"
			#defense_label.label_settings.font_color = Color.RED

func select_character(character_data:CharacterData):
	stats_name.text = character_data.full_name
	stats_class.text = "Class: " + character_data.get_character_class_name()
	stats_hp.text = str(character_data.hp)
	stats_power.text = str(character_data.power)
	stats_defense.text = str(character_data.defense)
	stats_attack.text = str(character_data.attack)

func _on_sell_button_pressed(item_view:ItemView):
	var item = item_view.item_data
	Globals.money += floori(item.purchase_price * Globals.resale_modifier)
	
	if item.equipped_by:
		item.equipped_by.unequip_item(item)
	
	Globals.owned_items.erase(item)
	
	item_view.queue_free()
