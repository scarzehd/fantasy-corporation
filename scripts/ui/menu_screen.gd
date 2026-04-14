extends Node2D

const MAIN_SCENE:PackedScene = preload("uid://b5v8bj3uciobn")
const TUTORIAL_SCENE:PackedScene = preload("uid://c3787dbl2ndi2")

func _on_play_button_pressed() -> void:
	await Fade.fade_out().finished
	get_tree().change_scene_to_packed(MAIN_SCENE)
	Fade.fade_in()


func _on_tutorial_button_pressed() -> void:
	await Fade.fade_out().finished
	get_tree().change_scene_to_packed(TUTORIAL_SCENE)
	Fade.fade_in()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
