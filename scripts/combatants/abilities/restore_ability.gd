extends Ability
class_name RestoreAbility

func _ready() -> void:
	Battle.instance.combatant_clicked.connect(_on_combatant_clicked)

func _button_toggled(toggled_on:bool):
	if toggled_on:
		button.text = "Select Target"
	else:
		button.text = ability_name

func _on_combatant_clicked(clicked_combatant:Combatant):
	if not button:
		return
	
	if not button.button_pressed:
		return
	
	if clicked_combatant is not PlayerCombatant:
		return
	
	button.button_pressed = false
	
	clicked_combatant.heal(ceili(combatant.power * randf_range(1.9, 2.1)))
	
	combatant.end_turn()
