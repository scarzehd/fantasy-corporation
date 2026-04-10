extends Ability
class_name WhirlwindAbility

func _button_pressed():
	combatant.animation_player.play(combatant.attack_animation)
	combatant.end_turn()
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	var enemies:Array[Combatant] = []
	for other_combatant in Battle.instance.combatants:
		if other_combatant is not PlayerCombatant:
			enemies.append(other_combatant)
	
	var total_damage = combatant.power * 1.5
	var damage_per_enemy = ceili(min(total_damage / enemies.size(), combatant.power))
	
	for enemy in enemies:
		if RandomUtils.roll_attack(enemy.defense, ceili(combatant.attack * 0.75)):
			enemy.damage(damage_per_enemy * randf_range(0.9, 1.1))
		else:
			enemy.create_bounce_text("MISS", Color.WHITE, 40)
