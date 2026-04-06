extends TextureButton
class_name GlobeButton

const ADVENTURER_LISTING_TEMPLATE:PackedScene = preload("uid://c1e1b5ddgj3s8")
const BATTLE_SCENE:PackedScene = preload("uid://bax6tvgq726xt")

@onready var adventure_menu:CanvasLayer = %AdventureMenu
@onready var adventurer_listing_container:VBoxContainer = %AdventurerListingContainer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		adventure_menu.hide()
		get_viewport().set_input_as_handled()

func _on_pressed() -> void:
	adventure_menu.show()
	clear_ui()
	populate_ui()

func clear_ui():
	for child in adventurer_listing_container.get_children():
		if child is not AdventurerListing:
			continue
		
		child.queue_free()

func populate_ui():
	for character in Globals.hired_characters:
		var listing = ADVENTURER_LISTING_TEMPLATE.instantiate()
		listing.show()
		adventurer_listing_container.add_child(listing)
		adventurer_listing_container.move_child(listing, 0)
		listing.character_data = character


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(BATTLE_SCENE)
