extends CanvasLayer
class_name TutorialDialogue

const SCENE:PackedScene = preload("uid://cwjjpnlv61lfs")

@export var root:Control
signal dialogue_closed
signal dialogue_finished

@export var top_view:PanelContainer
@export var bottom_view:PanelContainer
@export var top_text_label:Label
@export var bottom_text_label:Label
@onready var bottom_skip_button: TextureButton = %BottomSkipButton
@onready var top_skip_button: TextureButton = %TopSkipButton

var top:bool = false

var text:Array[String] = ["Test"]
var current_text_index:int = 0

var tween:Tween

var can_close:bool = true

static func create_dialogue(new_text:Array[String], is_top:bool = false, new_can_close:bool = false) -> TutorialDialogue:
	var dialogue:TutorialDialogue = SCENE.instantiate()
	
	dialogue.top = is_top
	
	dialogue.top_view.visible = is_top
	dialogue.bottom_view.visible = not is_top
	
	dialogue.text = new_text
	
	dialogue.can_close = new_can_close
	
	#dialogue.top_text_label.text = text
	#dialogue.bottom_text_label.text = text
	
	return dialogue

func _ready() -> void:
	root.position.y = -500 if top else 500
	
	var open_tween:Tween = create_tween()
	open_tween.set_ease(Tween.EASE_OUT)
	open_tween.set_trans(Tween.TRANS_CUBIC)
	open_tween.tween_property(root, "position:y", 0, 0.3)
	
	top_skip_button.disabled = true
	bottom_skip_button.disabled = true
	
	await open_tween.finished
	
	top_skip_button.disabled = false
	bottom_skip_button.disabled = false
	
	show_text()


func show_text():
	if tween:
		tween.stop()
	
	top_text_label.text = text[current_text_index]
	bottom_text_label.text = text[current_text_index]
	
	top_text_label.visible_characters = 0
	bottom_text_label.visible_characters = 0
	
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(top_text_label, "visible_characters", top_text_label.text.length(), top_text_label.text.length() * 0.015)
	tween.tween_property(bottom_text_label, "visible_characters", bottom_text_label.text.length(), bottom_text_label.text.length() * 0.015)
	
	if current_text_index >= text.size() - 1:
		tween.finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	dialogue_finished.emit()
	if not can_close:
		top_skip_button.hide()
		bottom_skip_button.hide()

func skip_dialogue():
	tween.stop()
	top_text_label.visible_ratio = 1.0
	bottom_text_label.visible_ratio = 1.0
	if current_text_index >= text.size() - 1:
		_on_dialogue_finished()

func close_dialogue():
	_on_dialogue_finished()
	if tween:
		tween.stop()
	var close_tween:Tween = create_tween()
	close_tween.set_ease(Tween.EASE_IN)
	close_tween.set_trans(Tween.TRANS_CUBIC)
	close_tween.tween_property(root, "position:y", -500 if top else 500, 0.3)
	
	await close_tween.finished
	dialogue_closed.emit()
	queue_free()

func _on_close_button_pressed() -> void:
	if tween and tween.is_running():
		skip_dialogue()
		return
	
	current_text_index += 1
	
	if current_text_index >= text.size():
		if can_close:
			close_dialogue()
		
		return
	
	show_text()
