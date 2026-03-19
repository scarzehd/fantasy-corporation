extends TextureButton
class_name MailBox

@onready var letters_menu:Panel = %LettersMenu
@onready var previous_letter_button:Button = %PreviousLetterButton
@onready var next_letter_button:Button = %NextLetterButton
@onready var letter_container:HBoxContainer = %LetterContainer

var letters:Array[Letter]
var current_index:int = 0 : set = _set_current_index

var tween:Tween

func _ready() -> void:
	for child in letter_container.get_children():
		if child is Letter:
			letters.append(child)
	
	_set_current_index(current_index)

func _on_pressed() -> void:
	if letters.size() > 0:
		letters_menu.show()
		current_index = 0

func _set_current_index(new_value:int):
	current_index = clamp(new_value, 0, max(letters.size() - 1, 0))
	
	previous_letter_button.disabled = false
	next_letter_button.disabled = false
	
	if current_index <= 0:
		previous_letter_button.disabled = true
	
	if current_index >= letters.size() - 1:
		next_letter_button.disabled = true
	
	#letter_container.position.x = -1920 * new_value
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(letter_container, "position:x", -1920 * new_value, 0.25)

func _on_previous_letter_button_pressed() -> void:
	current_index -= 1

func _on_next_letter_button_pressed() -> void:
	current_index += 1

func _on_close_button_pressed() -> void:
	letters_menu.hide()

func _on_confirm_button_pressed() -> void:
	for letter in letters:
		letter._complete()
	
	letters.clear()
	
	letters_menu.hide()
