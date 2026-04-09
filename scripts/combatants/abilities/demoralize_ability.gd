extends Ability
class_name DemoralizeAbility

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
	
	if clicked_combatant is PlayerCombatant:
		return
	
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	if RandomUtils.roll_attack(clicked_combatant.defense, combatant.attack):
		clicked_combatant.damage(ceili(combatant.power * 0.5 * randf_range(0.9, 1.1)))
		
		var status_effect = StatusEffect.new()
		status_effect.id = "demoralize"
		status_effect.attack = -combatant.power
		status_effect.power = -ceili(combatant.power * 0.25)
		status_effect.has_duration = true
		status_effect.refresh_duration = true
		status_effect.duration = 2
		
		clicked_combatant.add_status_effect(status_effect)
		await get_tree().create_timer(0.05).timeout
		var bounce_text = clicked_combatant.create_bounce_text("Demoralized", Color.YELLOW, 40)
		bounce_text.position.y -= 50
	else:
		clicked_combatant.create_bounce_text("Resisted", Color.WHITE, 40)
