extends Combatant

@export var status_effect:StatusEffect

@onready var animation_player:AnimationPlayer = %AnimationPlayer

func start_turn():
	super()
	var players:Array[PlayerCombatant]
	
	for combatant in Battle.instance.combatants:
		if combatant is PlayerCombatant:
			players.append(combatant)
	
	var target = players.pick_random()
	
	animation_player.play("attack")
	end_turn()
	
	var anim = animation_player.get_animation("attack")
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	if RandomUtils.roll_attack(target.defense, attack):
		target.damage(roundi(power * randf_range(0.9, 1.1)))
		
		if randf() < 0.5:
		#if randf() < 1:
			target.add_status_effect(status_effect.duplicate())
			await get_tree().create_timer(0.15).timeout
			var bounce_text = target.create_bounce_text("Bleeding", Color.RED, 40)
			bounce_text.position.y -= 50
	else:
		target.create_bounce_text("MISS", Color.WHITE, 40)
