extends TextureButton
class_name DoorButton

@onready var confirmation_popup:CanvasLayer = %ConfirmationPopup

func _on_pressed() -> void:
	confirmation_popup.show()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.key_label == Key.KEY_ESCAPE:
		confirmation_popup.hide()

func _on_cancel_button_pressed() -> void:
	confirmation_popup.hide()

func _on_accept_button_pressed() -> void:
	TimeManager.advance_day()
	confirmation_popup.hide()
