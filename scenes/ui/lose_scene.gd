extends Node2D

const MAIN_SCENE:String = "uid://b5v8bj3uciobn"

func _ready() -> void:
	Globals.reset()
	Fade.fade_in()

func _on_button_pressed() -> void:
	await Fade.fade_out(2).finished
	get_tree().change_scene_to_file(MAIN_SCENE)
	Fade.fade_in()
