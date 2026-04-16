extends Ability
class_name HealingSong

const STATUS_ICON:Texture = preload("uid://bkb6d38cyvj2b")

@export var audio_stream_player:AudioStreamPlayer

func _button_pressed():
	if combatant.acted:
		return
	
	combatant.acted = true
	
	combatant.animation_player.play(combatant.attack_animation)
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	audio_stream_player.play()
	
	for other_combatant in Battle.instance.combatants:
		if other_combatant is PlayerCombatant:
			var status_effect = StatusEffect.new()
			status_effect.has_duration = true
			status_effect.duration = 2
			status_effect.refresh_duration = true
			status_effect.damage = floori(-combatant.power * 0.5)
			status_effect.name = "Healing Song"
			status_effect.id = "healing_song"
			status_effect.icon = STATUS_ICON
			
			other_combatant.add_status_effect(status_effect)
			
			other_combatant.create_bounce_text("Healing Song", Color.GREEN, 40)
	
	combatant.end_turn()
