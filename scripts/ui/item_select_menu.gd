extends Panel
class_name ItemSelectMenu

signal item_selected(item_data:ItemData)

@onready var item_button_container:GridContainer = %ItemButtonContainer

const ITEM_BUTTON_SCENE:PackedScene = preload("uid://bm4w1n4lkd6f3")

var item_type:ItemData.ItemType

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _ready() -> void:
	for item in Globals.owned_items:
		if item.item_type == item_type:
			var button = ITEM_BUTTON_SCENE.instantiate()
			button.show()
			item_button_container.add_child(button)
			button.item_data = item
			button.pressed.connect(_on_item_button_clicked.bind(item))

func _on_item_button_clicked(item_data:ItemData):
	item_selected.emit(item_data)
	queue_free()


func _on_unequip_button_pressed() -> void:
	item_selected.emit(null)
	queue_free()
