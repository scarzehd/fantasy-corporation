extends Control
class_name BattleHUD

@onready var name_label: Label = %NameLabel
@onready var portrait: TextureRect = %Portrait
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_bar_label: Label = %HealthBarLabel
@onready var attack_container: GridContainer = %AttackContainer
@onready var attack_button_template: Button = %AttackButtonTemplate
@onready var status_effect_container: GridContainer = %StatusEffectContainer
@onready var status_effect_template: PanelContainer = %StatusEffectTemplate


func _on_turn_started(combatant:Combatant):
	reset_ui()
	
	setup_combatant(combatant)
	
	if combatant is PlayerCombatant:
		setup_player_combatant(combatant)
	

func reset_ui():
	name_label.text = ""
	
	for child in attack_container.get_children():
		if child == attack_button_template:
			continue
		
		child.queue_free()
	
	for child in status_effect_container.get_children():
		if child == status_effect_template:
			continue
		
		child.queue_free()

func setup_player_combatant(combatant:PlayerCombatant):
	for ability in combatant.abilities:
		var button = attack_button_template.duplicate()
		button.show()
		attack_container.add_child(button)
		ability.setup_button(button)

func setup_combatant(combatant:Combatant):
	name_label.text = combatant.combatant_name
	health_bar.max_value = combatant.max_hp
	health_bar.value = combatant.current_hp
	portrait.texture = combatant.portrait
	
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
