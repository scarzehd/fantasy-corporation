extends Control
class_name BattleHUD

@onready var name_label: Label = %NameLabel
@onready var portrait: TextureRect = %Portrait
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_bar_label: Label = %HealthBarLabel
@onready var attack_label:Label = %AttackLabel
@onready var defense_label:Label = %DefenseLabel
@onready var power_label:Label = %PowerLabel

@onready var attack_container: HBoxContainer = %AttackContainer
@onready var attack_button_template: TextureButton = %AttackButtonTemplate
@onready var status_effect_container: VBoxContainer = %StatusEffectContainer
@onready var status_effect_template: PanelContainer = %StatusEffectTemplate

@onready var attack_name_label:Label = %AttackNameLabel
@onready var attack_description_label:Label = %AttackDescriptionLabel

@onready var mission_end_panel:Control = %MissionEndPanel
@onready var header_label:Label = %HeaderLabel
@onready var deaths_label:Label = %DeathsLabel
@onready var money_label:Label = %MoneyLabel
@onready var total_label:Label = %TotalLabel
@onready var lost_item_template:PanelContainer = %LostItemTemplate
@onready var items_lost_container:PanelContainer = %ItemsLostContainer

func _on_turn_ended(_combatant:Combatant):
	for button in attack_container.get_children():
		if button == attack_button_template:
			continue
		
		button.disabled = true

func _on_turn_started(combatant:Combatant):
	reset_ui()
	setup_combatant(combatant)
	
	if combatant is PlayerCombatant:
		setup_player_combatant(combatant)

func reset_ui():
	health_bar_label.text = ""
	health_bar.value = 0
	health_bar.max_value = 1.0
	name_label.text = ""
	attack_label.text = ""
	defense_label.text = ""
	power_label.text = ""
	
	attack_name_label.text = ""
	attack_description_label.text = ""
	
	for child in attack_container.get_children():
		if child == attack_button_template:
			continue
		
		child.queue_free()
	
	for child in status_effect_container.get_children():
		if child == status_effect_template:
			continue
		
		child.queue_free()
	
	portrait.texture = null

func setup_player_combatant(combatant:PlayerCombatant):
	for ability in combatant.abilities:
		var button = attack_button_template.duplicate()
		button.show()
		attack_container.add_child(button)
		ability.setup_button(button)
		if button.toggle_mode:
			button.button_group = attack_button_template.button_group
		
		button.mouse_entered.connect(button_hovered.bind(ability))

func button_hovered(ability:Ability):
	attack_name_label.text = ability.ability_name
	attack_description_label.text = ability.description

func setup_combatant(combatant:Combatant):
	name_label.text = combatant.combatant_name
	portrait.texture = combatant.portrait
	health_bar.max_value = combatant.max_hp
	health_bar.value = combatant.current_hp
	health_bar_label.text = str(combatant.current_hp) + " / " + str(combatant.max_hp)
	attack_label.text = str(combatant.attack)
	defense_label.text = str(combatant.defense)
	power_label.text = str(combatant.power)
	
	for status_effect in combatant.status_effects:
		var template = status_effect_template.duplicate()
		template.show()
		status_effect_container.add_child(template)
		
		var status_name_label:Label = template.find_child("NameLabel", true, false)
		status_name_label.text = status_effect.name
		
		var duration_label:Label = template.find_child("DurationLabel", true, false)
		duration_label.text = str(status_effect.duration) + " turns left"
		
		var stat_label:Label = template.find_child("StatLabel", true, false)
		
		var stat_container:VBoxContainer = template.find_child("StatContainer", true, false)
		
		if status_effect.damage != 0:
			var label:Label = stat_label.duplicate()
			label.show()
			stat_container.add_child(label)
			label.label_settings = label.label_settings.duplicate()
			label.text = str(abs(status_effect.damage)) + " "
			
			if status_effect.damage > 0:
				label.text += "Damage"
				label.label_settings.font_color = Color.RED
			if status_effect.damage < 0:
				label.text += "Healing"
				label.label_settings.font_color = Color.GREEN
		
		if status_effect.attack != 0:
			var label:Label = stat_label.duplicate()
			label.show()
			stat_container.add_child(label)
			label.label_settings = label.label_settings.duplicate()
			
			if status_effect.attack > 0:
				label.text = "+" + str(status_effect.attack) + " Attack"
				label.label_settings.font_color = Color.GREEN
			if status_effect.attack < 0:
				label.text = str(status_effect.attack) + " Attack"
				label.label_settings.font_color = Color.RED
		
		if status_effect.power != 0:
			var label:Label = stat_label.duplicate()
			label.show()
			stat_container.add_child(label)
			label.label_settings = label.label_settings.duplicate()
			
			if status_effect.power > 0:
				label.text = "+" + str(status_effect.power) + " Power"
				label.label_settings.font_color = Color.GREEN
			if status_effect.power < 0:
				label.text = str(status_effect.power) + " Power"
				label.label_settings.font_color = Color.RED
		
		if status_effect.defense != 0:
			var label:Label = stat_label.duplicate()
			label.show()
			stat_container.add_child(label)
			label.label_settings = label.label_settings.duplicate()
			
			if status_effect.defense > 0:
				label.text = "+" + str(status_effect.defense) + " Defense"
				label.label_settings.font_color = Color.GREEN
			if status_effect.defense < 0:
				label.text = str(status_effect.defense) + " Defense"
				label.label_settings.font_color = Color.RED

func _on_battle_ended(won:bool):
	mission_end_panel.show()
	header_label.text = "Great Success!" if won else "Colossal Failure!"
	var lost_items:Array[ItemData]
	for combatant in Battle.instance.casualties:
		for slot in combatant.character_data.items:
			lost_items.append(combatant.character_data.items[slot])
	
	#var death_penalties = Battle.instance.casualties.size() * Globals.LIFE_INSURANCE_PRICE
	#Globals.money -= death_penalties
	#deaths_label.text = "Life insurance payouts: " + str(death_penalties)
	var reward = 0
	if won:
		reward = RandomUtils.generate_in_range(750, 1000, 0.75)
		if Battle.instance.waves > 1:
			reward += RandomUtils.generate_in_range(250, 500, 0.75) * Battle.instance.waves - 1
	
	Globals.money += reward
	money_label.text = "Money plundered: " + str(reward)
	#var total = reward - death_penalties
	#total_label.text = "Total profit: " + str(total)
	if reward <= 0:
		money_label.label_settings.font_color = Color.RED
	elif reward > 0:
		money_label.label_settings.font_color = Color.GREEN

	
	if lost_items.size() > 0:
		items_lost_container.show()
		
		for item in lost_items:
			var template = lost_item_template.duplicate()
			template.show()
			lost_item_template.add_sibling(template)
			
			var item_name_label:Label = template.find_child("NameLabel", true, false)
			item_name_label.text = item.item_name
			var item_portrait:TextureRect = template.find_child("Portrait", true, false)
			item_portrait.texture = item.item_portrait
			
			Globals.owned_items.erase(item)
	
	for character_data in Globals.hired_characters:
		for item in character_data.items.values():
			character_data.unequip_item(item)
	
	Globals.hired_characters.clear()

func _on_button_pressed() -> void:
	TimeManager.successful_adventure()
	TimeManager.advance_day()
	await TimeManager.day_ended
	get_tree().change_scene_to_file("uid://b5v8bj3uciobn")
