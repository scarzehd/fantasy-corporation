extends Node

@export var button_hover_sound:RandomAudioStreamPlayer
@export var button_press_sound:RandomAudioStreamPlayer
@export var money_press_sound:RandomAudioStreamPlayer
@export var battle_music:AudioStreamPlayer
@export var office_music:AudioStreamPlayer

const OFFICE_MUSIC_VOLUME:float = 0.5
const BATTLE_MUSIC_VOLUME:float = 0.2

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node):
	if node is BaseButton:
		node.mouse_entered.connect(button_hover_sound.play_random)
		
		if not node.is_in_group("no_press_sound"):
			if node.is_in_group("money_press_sound"):
				node.pressed.connect(money_press_sound.play_random)
			else:
				node.pressed.connect(button_press_sound.play_random)
