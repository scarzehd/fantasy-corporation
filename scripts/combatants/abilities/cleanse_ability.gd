extends Ability
class_name CleanseAbility

@export var audio_stream_player:AudioStreamPlayer

#func _button_toggled(toggled_on:bool):
	#if toggled_on:
		#button.text = "Select Target"
	#else:
		#button.text = ability_name
func _ready() -> void:
	Battle.instance.combatant_clicked.connect(_on_combatant_clicked)

func _on_combatant_clicked(clicked_combatant:Combatant):
	if not button:
		return
	
	if not button.button_pressed:
		return
	
	if combatant.acted:
		return
	
	combatant.acted = true
	
	for status_effect in clicked_combatant.status_effects.duplicate():
		if status_effect.negative:
			status_effect.end_status_effect()
	
	combatant.animation_player.play(combatant.attack_animation)
	
	var anim = combatant.animation_player.get_animation(combatant.attack_animation)
	
	if anim.has_marker("impact"):
		await get_tree().create_timer(anim.get_marker_time("impact")).timeout
	
	audio_stream_player.play()
	
	clicked_combatant.create_bounce_text("Cleanse", Color.WHITE, 40)
	
	combatant.end_turn()
