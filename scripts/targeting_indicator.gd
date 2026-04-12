extends Node2D
class_name TargetingIndicator

@onready var animation_player:AnimationPlayer = %AnimationPlayer
@onready var sprite:Sprite2D = %Sprite2D

var select_animation_playing:bool = false

func _ready() -> void:
	hide()

func select_target():
	select_animation_playing = true
	animation_player.pause()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position:y", -50, 0.1)
	tween.tween_property(sprite, "modulate:a", 0, 0.2)
	await tween.finished
	hide()
	animation_player.play()
	position.y = 0
	select_animation_playing = false
