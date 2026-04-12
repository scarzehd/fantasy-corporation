extends Combatant

@onready var animation_player:AnimationPlayer = %AnimationPlayer

@export var status_effect:StatusEffect

func start_turn():
	super()
	
	var lowest_player:PlayerCombatant = null
	
	for combatant in Battle.instance.combatants:
		if combatant is not PlayerCombatant:
			continue
		
		if not lowest_player:
			lowest_player = combatant
		
		if combatant.current_hp < lowest_player.current_hp:
			lowest_player = combatant
	
	if not lowest_player:
		end_turn()
	
	animation_player.play("attack")
	
	var anim = animation_player.get_animation("attack")
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	if RandomUtils.roll_attack(lowest_player.defense, attack):
		lowest_player.damage(ceili(power * 0.35 * randf_range(0.9, 1.1)))
		
		var effect = status_effect.duplicate()
		effect.defense = -power
		effect.attack = -power
		lowest_player.add_status_effect(effect)
		await get_tree().create_timer(0.15).timeout
		var bounce_text = lowest_player.create_bounce_text("Doomed", Color.BLACK, 40)
		bounce_text.position.y -= 50
		bounce_text.label.label_settings.outline_color = Color.WHITE
		bounce_text.label.label_settings.outline_size = 2
	else:
		lowest_player.create_bounce_text("MISS", Color.WHITE, 40)
	
	end_turn()
