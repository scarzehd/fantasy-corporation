extends Button

const PAUSE_UI:PackedScene = preload("uid://o2kaxcx1anry")

func _on_pressed() -> void:
	add_child(PAUSE_UI.instantiate())
