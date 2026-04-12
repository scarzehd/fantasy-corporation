extends Combatant

@onready var animation_player:AnimationPlayer = %AnimationPlayer

func _on_defeat():
	animation_player.play("global_enemy_animations/death")
	await animation_player.animation_finished
	queue_free()

func _on_damage(_amount:int):
	animation_player.play("global_enemy_animations/hurt")
	animation_player.queue("idle")

func start_turn():
	super()
	var players:Array[PlayerCombatant]
	
	for combatant in Battle.instance.combatants:
		if combatant is PlayerCombatant:
			players.append(combatant)
	
	var target = players.pick_random()
	
	if RandomUtils.roll_attack(target.defense, attack):
		target.damage(roundi(power * randf_range(0.9, 1.1)))
	else:
		target.create_bounce_text("MISS", Color.WHITE, 40)
	
	animation_player.play("attack")
	
	await animation_player.animation_finished
	
	end_turn()
