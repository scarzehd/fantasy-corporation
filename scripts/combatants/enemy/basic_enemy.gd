extends Combatant

@onready var animation_player:AnimationPlayer = %AnimationPlayer

@export var status_effect:StatusEffect

func _set_current_hp(new_value):
	super(new_value)
	if new_value <= 0:
		hide()
		collision_layer = 0

func start_turn():
	super()
	var players:Array[PlayerCombatant]
	
	for combatant in Battle.instance.combatants:
		if combatant is PlayerCombatant:
			players.append(combatant)
	
	var target = players.pick_random()
	
	if RandomUtils.roll_attack(target.defense, attack):
		target.damage(roundi(power * randf_range(0.9, 1.1)))
		
		if randf() < 0.25:
			target.add_status_effect(status_effect.duplicate())
			await get_tree().create_timer(0.15).timeout
			var bounce_text = target.create_bounce_text("Poisoned", Color.DARK_GREEN, 40)
			bounce_text.position.y -= 50
			
	else:
		target.create_bounce_text("MISS", Color.WHITE, 40)
	
	animation_player.play("attack")
	
	await animation_player.animation_finished
	
	end_turn()
