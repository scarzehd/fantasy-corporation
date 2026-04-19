extends TextureButton
class_name GlobeButton

const ADVENTURER_LISTING_TEMPLATE:PackedScene = preload("uid://c1e1b5ddgj3s8")
const BATTLE_SCENE:PackedScene = preload("uid://bax6tvgq726xt")
const TUTORIAL_BATTLE:PackedScene = preload("uid://0o3x7ybwogwf")

@onready var adventure_menu:CanvasLayer = %AdventureMenu
@onready var adventurer_listing_container:VBoxContainer = %AdventurerListingContainer
@onready var start_button:Button = %StartButton
@onready var normal:Sprite2D = %Normal
@onready var hover:Sprite2D = %Hover

@export var tutorial_mode:bool = false

func _unhandled_input(event: InputEvent) -> void:
	if tutorial_mode:
		return
	
	if event.is_action_pressed("ui_cancel"):
		_on_exit_button_pressed()

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
	start_button.disabled = true
	
	if Globals.hired_characters.size() > 0:
		start_button.disabled = false
	
	var characters = Globals.hired_characters.duplicate()
	characters.reverse()
	
	for character in characters:
		var listing = ADVENTURER_LISTING_TEMPLATE.instantiate()
		listing.show()
		adventurer_listing_container.add_child(listing)
		adventurer_listing_container.move_child(listing, 0)
		listing.character_data = character


func _on_start_button_pressed() -> void:
	if SoundManager.office_music.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(SoundManager.office_music, "volume_linear", 0, 0.5)
		tween.tween_callback(SoundManager.office_music.stop)
	await Fade.fade_out(0.5).finished
	if tutorial_mode:
		get_tree().change_scene_to_packed(TUTORIAL_BATTLE)
		return
	get_tree().change_scene_to_packed(BATTLE_SCENE)


func _on_exit_button_pressed() -> void:
	adventure_menu.hide()
	get_viewport().set_input_as_handled()


func _on_mouse_entered() -> void:
	normal.hide()
	hover.show()

func _on_mouse_exited() -> void:
	normal.show()
	hover.hide()
