extends Letter
class_name ResumeLetter

@onready var trait_label_container:VBoxContainer = %TraitLabelContainer
@onready var trait_label_template:Label = %TraitLabelTemplate

@onready var portrait:TextureRect = %Portrait
@onready var name_label:Label = %NameLabel
@onready var class_label:Label = %ClassLabel
@onready var accept_button:Button = %AcceptButton
@onready var hp_label:Label = %HPLabel
@onready var power_label:Label = %PowerLabel
@onready var defense_label:Label = %DefenseLabel

var character_data:CharacterData : set = _set_character_data

func _set_character_data(new_character_data:CharacterData):
	character_data = new_character_data
	
	if not is_node_ready():
		await ready
	
	portrait.texture = character_data.portrait
	name_label.text = character_data.full_name
	class_label.text = character_data.get_class_name()
	hp_label.text = str(character_data.hp)
	power_label.text = str(character_data.power)
	defense_label.text = str(character_data.defense)

func _complete():
	super()
	if accept_button.button_pressed:
		Globals.hired_characters.append(character_data)
