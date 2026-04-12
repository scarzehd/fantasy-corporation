extends PanelContainer
class_name ItemView

@onready var name_label:Label = %NameLabel
@onready var portrait:TextureRect = %Portrait
@onready var hp_label:Label = %HPLabel
@onready var attack_label:Label = %AttackLabel
@onready var power_label:Label = %PowerLabel
@onready var defense_label:Label = %DefenseLabel
@onready var equipped_label:Label = %EquippedLabel
@onready var attack:HBoxContainer = %Attack
@onready var power:HBoxContainer = %Power
@onready var hp:HBoxContainer = %HP
@onready var defense:HBoxContainer = %Defense

var item_data:ItemData : set = _set_item_data

func _set_item_data(new_value:ItemData):
	item_data = new_value
	
	if not is_node_ready():
		await ready
	
	name_label.text = new_value.item_name
	
	portrait.texture = new_value.item_portrait
	
	if new_value.equipped_by:
		equipped_label.show()
		equipped_label.text = "Equipped by " + new_value.equipped_by.first_name
	
	if new_value.hp != 0:
		hp.show()
		hp_label.text = "+" + str(new_value.hp) + " HP"
		hp_label.label_settings = hp_label.label_settings.duplicate()
	if new_value.hp < 0:
		hp_label.text = str(new_value.hp) + " HP"
		hp_label.label_settings.font_color = Color.RED
	
	if new_value.attack != 0:
		attack.show()
		attack_label.text = "+" + str(new_value.attack) + " Attack"
		attack_label.label_settings = attack_label.label_settings.duplicate()
	if new_value.attack < 0:
		attack_label.text = str(new_value.attack) + " Attack"
		attack_label.label_settings.font_color = Color.RED
	
	if new_value.power != 0:
		power.show()
		power_label.text = "+" + str(new_value.power) + " Power"
		power_label.label_settings = power_label.label_settings.duplicate()
	if new_value.power < 0:
		power_label.text = str(new_value.power) + " Power"
		power_label.label_settings.font_color = Color.RED
	
	if new_value.defense != 0:
		defense.show()
		defense_label.text = "+" + str(new_value.defense) + " Defense"
		defense_label.label_settings = defense_label.label_settings.duplicate()
	if new_value.defense < 0:
		defense_label.text = str(new_value.defense) + " Defense"
		defense_label.label_settings.font_color = Color.RED
