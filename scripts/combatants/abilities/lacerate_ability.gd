extends Ability
class_name LacerateAbility

const STATUS_ICON:Texture = preload("uid://remqshuqtmhy")

func _ready() -> void:
	Battle.instance.combatant_clicked.connect(_on_combatant_clicked)

#func _button_toggled(toggled_on:bool):
	#if toggled_on:
		#button.text = "Select Target"
	#else:
		#button.text = ability_name

func _on_combatant_clicked(clicked_combatant:Combatant):
	if not button:
		return
	
	if not button.button_pressed:
		return
	
	if clicked_combatant is PlayerCombatant:
		return
	
	if combatant.acted:
		return
	
	combatant.acted = true
	
	clicked_combatant.targeting_indicator.select_target()
	
	button.button_pressed = false
	
	combatant.animation_player.play(combatant.attack_animation)
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	if RandomUtils.roll_attack(clicked_combatant.defense, combatant.attack):
		clicked_combatant.damage(roundi(combatant.power * 0.5 * randf_range(0.9, 1.1)))
		var status_effect = StatusEffect.new()
		status_effect.id = "lacerate"
		status_effect.name = "Bleed"
		status_effect.defense = -ceili(combatant.power * 2)
		status_effect.damage = ceili(combatant.power * 0.25)
		status_effect.has_duration = true
		status_effect.refresh_duration = true
		status_effect.duration = 4
		status_effect.icon = STATUS_ICON
		
		clicked_combatant.add_status_effect(status_effect)
		await get_tree().create_timer(0.05).timeout
		var bounce_text = clicked_combatant.create_bounce_text("Bleeding", Color.RED, 40)
		bounce_text.position.y -= 50
	else:
		clicked_combatant.create_bounce_text("MISS", Color.WHITE, 40)
	
	combatant.end_turn()
