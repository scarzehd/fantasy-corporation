extends VBoxContainer
class_name ItemSlotButton

const ITEM_SELECT_MENU_SCENE:PackedScene = preload("uid://bn3mujlqi2lwu")

signal item_selected(item_data:ItemData)

@export var item_slot:ItemData.ItemSlot = ItemData.ItemSlot.Weapon

@onready var slot_name_label:Label = %SlotNameLabel
@onready var button:Button = %Button
@onready var item_icon:TextureRect = %ItemIcon

var character_data:CharacterData : set = _set_character_data
var selected_item:ItemData : set = _set_selected_item

func _ready() -> void:
	slot_name_label.text = ItemData.get_slot_name(item_slot)

func _set_selected_item(new_value:ItemData):
	if selected_item and character_data:
		selected_item.equipped_by = null
		character_data.items.erase(item_slot)
	
	selected_item = new_value
	
	item_icon.hide()
	if new_value:
		if character_data:
			new_value.equipped_by = character_data
			character_data.items[item_slot] = new_value
		if new_value.item_portrait:
			item_icon.texture = new_value.item_portrait
			item_icon.show()

func _set_character_data(new_value:CharacterData):
	if character_data:
		character_data.changed.disconnect(_set_character_data.bind(character_data))
	character_data = new_value
	new_value.changed.connect(_set_character_data.bind(character_data))
	
	if not is_node_ready():
		await ready
	
	if new_value.items.has(item_slot):
		selected_item = new_value.items[item_slot]
	else:
		selected_item = null

func _on_button_pressed() -> void:
	var item_select_menu:ItemSelectMenu = ITEM_SELECT_MENU_SCENE.instantiate()
	item_select_menu.item_type = ItemData.get_type_for_slot(item_slot)
	add_child(item_select_menu)
	item_select_menu.item_selected.connect(_on_item_selected)

func _on_item_selected(item_data:ItemData):
	selected_item = item_data
	item_selected.emit(item_data)
