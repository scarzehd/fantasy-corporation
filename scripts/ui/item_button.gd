extends Button
class_name ItemButton

@onready var item_view:ItemView = %ItemView
@onready var equipped_panel:Panel = %EquippedPanel
@onready var equipped_label:Label = %EquippedLabel

var item_data:ItemData : set = _set_item_data

func _set_item_data(new_value:ItemData):
	item_data = new_value
	
	if not is_node_ready():
		await ready
	
	item_view.item_data = new_value
	equipped_panel.hide()
	if new_value.equipped_by:
		equipped_panel.show()
		equipped_label.text = "Equipped by " + new_value.equipped_by.first_name
