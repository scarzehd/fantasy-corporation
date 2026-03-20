extends Node

signal day_started
signal day_ended

var day_number:int = 1

func _ready() -> void:
	await get_tree().process_frame
	day_started.emit()

func advance_day():
	await Fade.fade_out().finished
	day_ended.emit()
	day_number += 1
	await Fade.fade_in().finished
	day_started.emit()
