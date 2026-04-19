extends Control
class_name PauseUI

@onready var pause_menu:Panel = %PauseMenu
@onready var master_volume_slider:HSlider = %MasterVolumeSlider
@onready var music_slider:HSlider = %MusicSlider
@onready var ui_sounds_slider:HSlider = %UISoundsSlider
@onready var other_sounds_slider:HSlider = %OtherSoundsSlider
@onready var quit_menu:Panel = %QuitMenu
@onready var quit_button:Button = %QuitButton
@onready var cancel_button:Button = %CancelButton
@onready var quit_menu_button:Button = %QuitMenuButton

func _ready() -> void:
	master_volume_slider.value = AudioServer.get_bus_volume_linear(0)
	music_slider.value = AudioServer.get_bus_volume_linear(1)
	ui_sounds_slider.value = AudioServer.get_bus_volume_linear(2)
	other_sounds_slider.value = AudioServer.get_bus_volume_linear(3)
	
	master_volume_slider.value_changed.connect(func(value): AudioServer.set_bus_volume_linear(0, value))
	music_slider.value_changed.connect(func(value): AudioServer.set_bus_volume_linear(1, value))
	ui_sounds_slider.value_changed.connect(func(value): AudioServer.set_bus_volume_linear(2, value))
	other_sounds_slider.value_changed.connect(func(value): AudioServer.set_bus_volume_linear(3, value))
	
	if get_tree().current_scene.name == "MenuScreen":
		quit_menu_button.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if quit_menu.visible:
			quit_menu.hide()
			return
		close()

func close():
	queue_free()


func _on_quit_menu_button_pressed() -> void:
	quit_menu.show()


func _on_cancel_button_pressed() -> void:
	quit_menu.hide()


func _on_quit_button_pressed() -> void:
	Globals.reset()
	var tween = get_tree().create_tween()
	tween.tween_property(SoundManager.battle_music, "volume_linear", 0, 1)
	tween.tween_callback(SoundManager.battle_music.stop)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(SoundManager.office_music, "volume_linear", 0, 1)
	tween2.tween_callback(SoundManager.office_music.stop)
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("uid://cyfybftq3otv3")
	Fade.fade_in()


func _on_close_menu_button_pressed() -> void:
	close()
