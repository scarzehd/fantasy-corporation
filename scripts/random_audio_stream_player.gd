extends AudioStreamPlayer
class_name RandomAudioStreamPlayer

@export var sounds:Array[AudioStream]
@export var pitch_range:Vector2 = Vector2(0.9, 1.1)
@export var volume_range:Vector2 = Vector2(1, 1)

func play_random(play_from:float = 0.0):
	stream = sounds.pick_random()
	pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	volume_linear = randf_range(volume_range.x, volume_range.y)
	play(play_from)
