extends Ability
class_name RestoreAbility

func _ready() -> void:
	Battle.instance.combatant_clicked.connect(_on_combatant_clicked)

#func _button_toggled(toggled_on:bool):
	#if toggled_on:
		#button.text = "Select Target"
	#else:
		#button.text = ability_name

func _on_combatant_clicked(clicked_combatant:Combatant):
	if not button:
		return
	
	if not button.button_pressed:
		return
	
	if clicked_combatant is not PlayerCombatant:
		return
	
	button.button_pressed = false
	
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	clicked_combatant.heal(ceili(combatant.power * randf_range(1.9, 2.1)))
