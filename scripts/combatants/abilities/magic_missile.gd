extends Ability
class_name MagicMissileAbility

func _button_pressed():
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	for i in range(3):
		while true:
			var target = Battle.instance.combatants.pick_random()
			if target is PlayerCombatant:
				continue

			target.damage(ceili(combatant.power * randf_range(0.2, 0.3)))
			break
		
		await get_tree().create_timer(0.25).timeout
