extends Button
class_name DoorButton

const LOSE_SCENE:PackedScene = preload("uid://dakppwtg6h8ey")

@onready var confirmation_popup:CanvasLayer = %ConfirmationPopup
@onready var bankruptcy_label:Label = %BankruptcyLabel
@onready var normal:Sprite2D = %Normal
@onready var hover:Sprite2D = %Hover
@onready var bell_audio_stream:RandomAudioStreamPlayer = %BellAudioStream

@export var tutorial_mode:bool = false

func _on_pressed() -> void:
	confirmation_popup.show()
	bankruptcy_label.hide()
	if Globals.money < 0:
		bankruptcy_label.show()
	
	bell_audio_stream.play_random()

func _input(event: InputEvent) -> void:
	if tutorial_mode:
		return
	
	if event is InputEventKey and event.key_label == Key.KEY_ESCAPE:
		confirmation_popup.hide()

func _on_cancel_button_pressed() -> void:
	confirmation_popup.hide()

func _on_accept_button_pressed() -> void:
	if tutorial_mode:
		await Fade.fade_out().finished
		confirmation_popup.hide()
		Fade.fade_in()
		return
	
	if Globals.money < 0:
		await Fade.fade_out().finished
		get_tree().change_scene_to_packed(LOSE_SCENE)
	
	TimeManager.advance_day()
	confirmation_popup.hide()

func _on_mouse_entered() -> void:
	normal.hide()
	hover.show()

func _on_mouse_exited() -> void:
	normal.show()
	hover.hide()
