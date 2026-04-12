extends Combatant

@onready var animation_player:AnimationPlayer = %AnimationPlayer

func start_turn():
	super()
	var players:Array[PlayerCombatant]
	
	for combatant in Battle.instance.combatants:
		if combatant is PlayerCombatant:
			players.append(combatant)

	animation_player.play("attack")
	
	var anim = animation_player.get_animation("attack")
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	for target in players:
		if RandomUtils.roll_attack(target.defense, attack):
			target.damage(roundi(float(power) / players.size() * randf_range(0.9, 1.1)))
		else:
			target.create_bounce_text("MISS", Color.WHITE, 40)
	
	end_turn()
