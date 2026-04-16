extends Combatant

const STATUS_ICON:Texture = preload("uid://cbb5ndqjdt5u6")

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
		
		var status = StatusEffect.new()
		status.id = "cringus"
		status.name = "Cringus?"
		status.duration = 3
		status.has_duration = true
		status.refresh_duration = true
		status.attack = RandomUtils.generate_in_range(roundi(-power), roundi(power))
		status.defense = RandomUtils.generate_in_range(roundi(-power), roundi(power))
		status.power = RandomUtils.generate_in_range(roundi(-0.5 * power), roundi(0.5 * power))
		status.damage = RandomUtils.generate_in_range(roundi(-power), roundi(power))
		status.icon = STATUS_ICON
		
		await get_tree().create_timer(0.15).timeout
		target.add_status_effect(status.duplicate())
		var bounce_text = target.create_bounce_text("Cringus?", Color.SADDLE_BROWN, 30)
		bounce_text.position.y -= 50
		self.add_status_effect(status.duplicate())
		self.create_bounce_text("Cringus?", Color.SADDLE_BROWN, 30)
	else:
		target.create_bounce_text("MISS", Color.WHITE, 40)
	
	end_turn()
