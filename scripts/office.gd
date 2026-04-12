extends Node2D
class_name Office

@onready var money_label:Label = %MoneyLabel
@onready var day_label:Label = %DayLabel
@onready var successful_adventures_label:Label = %SuccessfulAdventuresLabel
@onready var bankruptcy_panel:Panel = %BankruptcyPanel
@onready var hud_canvas_layer:CanvasLayer = %HUDCanvasLayer

func _ready() -> void:
	Globals.money_changed.connect(_on_money_changed)
	_on_money_changed(Globals.money, Globals.money)
	_on_day_ended()
	TimeManager.day_ended.connect(_on_day_ended)

func _on_money_changed(old_money:int, new_money:int):
	money_label.text = str(new_money)
	var change = new_money - old_money
	if change == 0:
		return
	
	var text = str(change)
	var color = Color.RED
	
	if change > 0:
		text = "+" + str(change)
		color = Color.GREEN
	
	var fall_text = FallText.create_fall_text(text, color, 50, -100, 1.5)
	hud_canvas_layer.add_child(fall_text)
	fall_text.global_position = money_label.get_global_rect().get_center()
	fall_text.global_position.x -= 11
	fall_text.start()
	
	if new_money < 0 and old_money >= 0:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(bankruptcy_panel, "size:y", 210, 0.75)
	elif new_money >= 0 and old_money < 0:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(bankruptcy_panel, "size:y", 0, 0.5)

func _on_day_ended():
	day_label.text = "Day " + str(TimeManager.day_number)
	successful_adventures_label.text = "Successful Adventures: " + str(TimeManager.successful_adventures)
