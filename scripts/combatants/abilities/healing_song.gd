extends Ability
class_name HealingSong

func _button_pressed():
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	for other_combatant in Battle.instance.combatants:
		if other_combatant is PlayerCombatant:
			if other_combatant == combatant:
				continue
			var status_effect = StatusEffect.new()
			status_effect.has_duration = true
			status_effect.duration = 2
			status_effect.refresh_duration = true
			status_effect.damage = -combatant.power
			status_effect.name = "Healing Song"
			status_effect.id = "healing_song"
			
			other_combatant.add_status_effect(status_effect)
