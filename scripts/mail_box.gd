extends TextureButton
class_name MailBox

const RESUME_LETTER_SCENE:PackedScene = preload("uid://cfp71tj5xdeqh")
const NEWSPAPER_LETTER_SCENE:PackedScene = preload("uid://c8wytlhkw0oa4")

@onready var letters_menu:CanvasLayer = %LettersMenu
@onready var previous_letter_button:TextureButton = %PreviousLetterButton
@onready var next_letter_button:TextureButton = %NextLetterButton
@onready var letter_container:HBoxContainer = %LetterContainer

var letters:Array[Letter]
var current_index:int = 0 : set = _set_current_index

var tween:Tween

func _ready() -> void:
	for child in letter_container.get_children():
		if child is Letter:
			letters.append(child)
	
	TimeManager.day_started.connect(_on_day_started)
	
	_set_current_index(current_index)

func _on_pressed() -> void:
	if letters.size() > 0:
		letters_menu.show()
		current_index = 0

func _set_current_index(new_value:int):
	current_index = clamp(new_value, 0, max(letters.size() - 1, 0))
	
	previous_letter_button.show()
	next_letter_button.show()
	
	if current_index <= 0:
		previous_letter_button.hide()
	
	if current_index >= letters.size() - 1:
		next_letter_button.hide()
	
	#letter_container.position.x = -1920 * new_value
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(letter_container, "position:x", -1920 * new_value, 0.25)

func _on_day_started():
	_on_confirm_button_pressed()
	
	var newspaper_letter:NewspaperLetter = NEWSPAPER_LETTER_SCENE.instantiate()
	letter_container.add_child(newspaper_letter)
	letters.append(newspaper_letter)
	
	var resume_letter:ResumeLetter = RESUME_LETTER_SCENE.instantiate()
	resume_letter.character_data = Globals.character_generator.generate()
	letter_container.add_child(resume_letter)
	letters.append(resume_letter)
	
	var weapon_generator:BasicItemGenerator = load("res://resources/item_generator/test_weapon_generator.tres")
	
	var items:Array[ItemData]
	for i in range(3):
		items.append(weapon_generator.generate_weapon())
	
	var armor_generator:BasicItemGenerator = load("res://resources/item_generator/test_armor_generator.tres")
	
	for i in range(3):
		items.append(armor_generator.generate_armor())
	
	var catalogue = load("res://scenes/ui/letters/basic_shop_catalogue.tscn").instantiate()
	letter_container.add_child(catalogue)
	letters.append(catalogue)
	catalogue.populate(items)

func _on_previous_letter_button_pressed() -> void:
	current_index -= 1

func _on_next_letter_button_pressed() -> void:
	current_index += 1

func _on_close_button_pressed() -> void:
	letters_menu.hide()

func _on_confirm_button_pressed() -> void:
	for letter in letters:
		letter.queue_free()
	
	letters.clear()
	
	letters_menu.hide()
