extends Ability
class_name MagicMissileAbility

func _button_pressed():
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	var enemies:Array[Combatant]
	
	for other_combatant in Battle.instance.combatants:
		if other_combatant is PlayerCombatant:
			continue
		
		enemies.append(other_combatant)
	
	for i in range(3):
		if enemies.size() <= 0:
			break
		
		var target = enemies.pick_random()

		target.damage(ceili(combatant.power * randf_range(0.2, 0.3)))
		
		if target.current_hp <= 0:
			enemies.erase(target)
		
		await get_tree().create_timer(0.25).timeout
