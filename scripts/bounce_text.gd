extends Node2D
class_name BounceText

const SCENE = preload("uid://bqeebyy6ca406")

@export var label:Label

static func create_bounce_text(text:String, color:Color = Color.WHITE, size:int = 16) -> BounceText:
	var node = SCENE.instantiate()
	
	node.label.text = text
	node.label.label_settings.font_color = color
	node.label.label_settings.font_size = size
	
	return node
