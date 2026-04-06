extends Node2D
class_name FallText

const SCENE = preload("uid://dpqcenv1ts053")

@export var label:Label

var fall_distance:float
var fall_time:float

static func create_fall_text(text:String, color:Color = Color.WHITE, size:int = 16, new_fall_distance:float = -50, new_fall_time:float = 0.5) -> FallText:
	var node = SCENE.instantiate()
	
	node.label.text = text
	node.label.label_settings.font_color = color
	node.label.label_settings.font_size = size
	
	node.fall_distance = new_fall_distance
	node.fall_time = new_fall_time
	
	return node

func start():
	var tween = create_tween() \
	.set_ease(Tween.EASE_OUT) \
	.set_trans(Tween.TRANS_CUBIC) \
	.set_parallel()
	
	tween.tween_property(self, "global_position:y", global_position.y - fall_distance, fall_time)
	tween.tween_property(self, "modulate:a", 0, fall_time).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	queue_free()
