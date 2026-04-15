extends Node

@export var button_hover_sound:RandomAudioStreamPlayer
@export var button_press_sound:RandomAudioStreamPlayer

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node):
	if node is BaseButton:
		node.mouse_entered.connect(button_hover_sound.play_random)
		
		if not node.is_in_group("no_press_sound"):
			node.pressed.connect(button_press_sound.play_random)
