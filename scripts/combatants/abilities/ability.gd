extends Node
class_name Ability

@export var ability_name:String = "Ability"
@export var toggle:bool = false
@export var icon:Texture
@export var select_icon:Texture
@export var hover_icon:Texture
@export_multiline var description:String

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

func _button_toggled(_toggled_on:bool):
	pass
