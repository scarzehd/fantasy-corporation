extends Letter
class_name ResumeLetter

#@onready var trait_label_container:VBoxContainer = %TraitLabelContainer
#@onready var trait_label_template:Label = %TraitLabelTemplate

@onready var portrait:TextureRect = %Portrait
@onready var name_label:Label = %NameLabel
@onready var class_label:Label = %ClassLabel
@onready var accept_button:Button = %AcceptButton
@onready var hp_label:Label = %HPLabel
@onready var attack_label:Label = %AttackLabel
@onready var power_label:Label = %PowerLabel
@onready var defense_label:Label = %DefenseLabel
#@onready var payment_label:Label = %PaymentLabel
@onready var insufficient_funds_label:Label = %InsufficientFundsLabel

var character_data:CharacterData : set = _set_character_data

var cost:int = 100 : set = _set_cost

var hired:bool = false

func _ready() -> void:
	cost = ceili(randi_range(150, 250) * Globals.adventurer_price_modifier)
	Globals.money_changed.connect(update_hireable.unbind(2))
	Globals.character_hired.connect(update_hireable.unbind(1))

func _set_character_data(new_character_data:CharacterData):
	character_data = new_character_data
	
	if not is_node_ready():
		await ready
	
	portrait.texture = character_data.portrait
	name_label.text = character_data.full_name
	class_label.text = character_data.get_character_class_name()
	hp_label.text = str(character_data.hp)
	attack_label.text = str(character_data.attack)
	power_label.text = str(character_data.power)
	defense_label.text = str(character_data.defense)

func _set_cost(new_value:int):
	cost = new_value
	
	if not is_node_ready():
		await ready
	
	update_hireable()

func _complete():
	super()
	if accept_button.button_pressed:
		Globals.hired_characters.append(character_data)
		Globals.money -= cost


func _on_accept_button_pressed() -> void:
	Globals.money -= cost
	Globals.hired_characters.append(character_data)
	hired = true
	update_hireable()

func update_hireable():
	#insufficient_funds_label.hide()
	insufficient_funds_label.visible_ratio = 0
	accept_button.disabled = false
	
	if hired:
		accept_button.text = "Hired"
		accept_button.disabled = true
		return
	
	if Globals.hired_characters.size() >= 4:
		accept_button.text = "Party Full"
		accept_button.disabled = true
		return
	
	if cost > Globals.money:
		#insufficient_funds_label.show()
		insufficient_funds_label.visible_ratio = 1
		#accept_button.text = "Insufficient Funds"
		accept_button.disabled = true
		return
	
	accept_button.text = "Hire for " + str(cost)
