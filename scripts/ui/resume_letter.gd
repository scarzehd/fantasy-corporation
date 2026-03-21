extends Letter
class_name ResumeLetter

@onready var trait_label_container:VBoxContainer = %TraitLabelContainer
@onready var trait_label_template:Label = %TraitLabelTemplate

@onready var portrait:TextureRect = %Portrait
@onready var name_label:Label = %NameLabel
@onready var class_label:Label = %ClassLabel
@onready var accept_button:Button = %AcceptButton
@onready var reject_button:Button = %RejectButton
@onready var hp_label:Label = %HPLabel
@onready var attack_label:Label = %AttackLabel
@onready var power_label:Label = %PowerLabel
@onready var defense_label:Label = %DefenseLabel
@onready var payment_label:Label = %PaymentLabel
@onready var insufficient_funds_label:Label = %InsufficientFundsLabel

var character_data:CharacterData : set = _set_character_data

var cost:int = 100 : set = _set_cost

func _ready() -> void:
	_set_cost(cost)

func _set_character_data(new_character_data:CharacterData):
	character_data = new_character_data
	
	if not is_node_ready():
		await ready
	
	portrait.texture = character_data.portrait
	name_label.text = character_data.full_name
	class_label.text = character_data.get_class_name()
	hp_label.text = str(character_data.hp)
	attack_label.text = str(character_data.attack)
	power_label.text = str(character_data.power)
	defense_label.text = str(character_data.defense)

func _set_cost(new_value:int):
	cost = new_value
	
	if not is_node_ready():
		await ready
	
	payment_label.text = "Desired Payment: " + str(cost)
	
	insufficient_funds_label.hide()
	accept_button.disabled = false
	if cost > Globals.money:
		insufficient_funds_label.show()
		reject_button.button_pressed = true
		accept_button.disabled = true

func _complete():
	super()
	if accept_button.button_pressed:
		Globals.hired_characters.append(character_data)
		Globals.money -= cost
