extends Node2D

const MAIN_SCENE:String = "uid://cyfybftq3otv3"

@onready var audio_stream_player:RandomAudioStreamPlayer = %AudioStreamPlayer
@onready var day_label: Label = %DayLabel
@onready var adventure_label: Label = %AdventureLabel

func _ready() -> void:
	day_label.text = "Made it to day " + str(TimeManager.day_number)
	adventure_label.text = str(TimeManager.successful_adventures) + " Successful adventures"
	Globals.reset()
	Fade.fade_in()

func _on_button_pressed() -> void:
	create_tween().tween_property(audio_stream_player, "volume_linear", 0, 1)
	await Fade.fade_out(2).finished
	get_tree().change_scene_to_file(MAIN_SCENE)
	Fade.fade_in()
