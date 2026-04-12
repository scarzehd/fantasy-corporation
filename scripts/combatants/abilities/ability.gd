extends Node
class_name Ability

enum TargetMode {
	None,
	Enemy,
	Player
}

@export var ability_name:String = "Ability"
@export var toggle:bool = false
@export var icon:Texture
@export var select_icon:Texture
@export var hover_icon:Texture
@export_multiline var description:String
@export var target_mode:TargetMode = TargetMode.None

var combatant:PlayerCombatant

var button:TextureButton


func setup_button(new_button:TextureButton):
	if button:
		button.toggled.disconnect(_button_toggled)
		button.pressed.disconnect(_button_pressed)
	button = new_button
	#button.text = ability_name
	button.toggle_mode = toggle
	button.toggled.connect(_button_toggled)
	button.pressed.connect(_button_pressed)
	if icon:
		button.texture_normal = icon
	
	if select_icon:
		button.texture_pressed = select_icon
	
	if hover_icon:
		button.texture_hover = hover_icon

func _button_pressed():
	pass

func _button_toggled(toggled_on:bool):
	if target_mode == TargetMode.None:
		return
	
	for target in Battle.instance.combatants:
		if (target is PlayerCombatant) and target_mode == TargetMode.Enemy:
			continue
		
		if (target is not PlayerCombatant) and target_mode == TargetMode.Player:
			continue
		
		if target.targeting_indicator.select_animation_playing:
			continue
		
		target.targeting_indicator.visible = toggled_on
