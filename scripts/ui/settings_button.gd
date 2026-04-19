extends Button

const PAUSE_UI:PackedScene = preload("uid://o2kaxcx1anry")

func _on_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(SoundManager.battle_music, "volume_linear", 0, 1)
	tween.tween_callback(SoundManager.battle_music.stop)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(SoundManager.office_music, "volume_linear", 0, 1)
	tween2.tween_callback(SoundManager.office_music.stop)

	add_child(PAUSE_UI.instantiate())
