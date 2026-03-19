extends TextureButton
class_name InventoryMenu

@onready var inventory_menu:Panel = %InventoryMenu

@onready var character_select_container:HBoxContainer = %CharacterSelectContainer
@onready var character_select_template:MarginContainer = %CharacterSelectTemplate

@onready var stats_name:Label = %StatsName
@onready var stats_class:Label = %StatsClass
@onready var stats_hp:Label = %StatsHP
@onready var hp_bar:ProgressBar = %HPBar
@onready var stats_power:Label = %StatsPower
@onready var power_bar:ProgressBar = %PowerBar
@onready var stats_defense:Label = %StatsDefense
@onready var defense_bar:ProgressBar = %DefenseBar
@onready var traits_container:VBoxContainer = %TraitsContainer

var character_select_buttons:Array[Button]

func _on_pressed() -> void:
	inventory_menu.show()
	populate_ui()

func _on_exit_button_pressed() -> void:
	inventory_menu.hide()

func clear_ui():
	for child in character_select_container.get_children():
		if child == character_select_template:
			continue
		
		child.queue_free()
	
	stats_hp.text = ""
	stats_power.text = ""
	stats_defense.text = ""

func populate_ui():
	var selected:bool = false
	for character_data in Globals.hired_characters:
		var template = character_select_template.duplicate()
		var name_label = template.find_child("CharacterName", true, false)
		var portrait = template.find_child("Portrait", true, false)
		var button = template.find_child("Button", true, false)
		
		name_label.text = character_data.first_name + " " + character_data.last_name
		portrait.texture = character_data.portrait
		button.pressed.connect(select_character.bind(character_data, button))
		
		character_select_buttons.append(button)
		character_select_container.add_child(template)
		template.show()
		
		if not selected:
			button.button_pressed = true
			select_character(character_data, button)
			selected = true

func select_character(character_data:CharacterData, button:Button):
	for other_button in character_select_buttons:
		other_button.button_pressed = false
		other_button.button_mask = MOUSE_BUTTON_MASK_LEFT
	
	button.button_mask = 0
	
	stats_name.text = character_data.first_name + " " + character_data.last_name
	# TODO replace this with something less stupid
	stats_class.text = "Class: Fighter" if character_data.character_class == CharacterData.CharacterClass.Fighter else "Class: Mage"
	stats_hp.text = str(character_data.hp)
	stats_power.text = str(character_data.power)
	stats_defense.text = str(character_data.defense)
