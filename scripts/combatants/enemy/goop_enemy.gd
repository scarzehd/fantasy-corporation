extends Combatant

@onready var animation_player:AnimationPlayer = %AnimationPlayer

func start_turn():
	super()
	var players:Array[PlayerCombatant]
	
	for combatant in Battle.instance.combatants:
		if combatant is PlayerCombatant:
			players.append(combatant)
	
	var target = players.pick_random()
	
	animation_player.play("attack")
	
	var anim = animation_player.get_animation("attack")
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	if RandomUtils.roll_attack(target.defense, attack):
		target.damage(roundi(power * randf_range(0.9, 1.1)))
		
		if randf() < 0.3 and target.character_data.items.size() > 0:
			var item = target.character_data.items.values().pick_random()
			target.character_data.unequip_item(item)
			Battle.instance.lost_items.append(item)
			await get_tree().create_timer(0.15).timeout
			var bounce_text = target.create_bounce_text("Dissolved " + item.item_name, Color.YELLOW_GREEN, 30)
			bounce_text.position.y -= 50
	else:
		target.create_bounce_text("MISS", Color.WHITE, 40)
	
	end_turn()
