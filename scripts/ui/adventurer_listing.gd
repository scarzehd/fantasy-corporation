extends HBoxContainer
class_name AdventurerListing

@onready var name_label:Label = %NameLabel
@onready var class_label:Label = %ClassLabel
@onready var portrait:TextureRect = %Portrait
@onready var hp_label:Label = %HPLabel
@onready var attack_label:Label = %AttackLabel
@onready var power_label:Label = %PowerLabel
@onready var defense_label:Label = %DefenseLabel
@onready var weapon_slot_button:ItemSlotButton = %WeaponSlotButton
@onready var armor_slot_button_1:ItemSlotButton = %ArmorSlotButton1
@onready var armor_slot_button_2:ItemSlotButton = %ArmorSlotButton2

var character_data:CharacterData : set = _set_character_data

func _ready() -> void:
	weapon_slot_button.item_selected.connect(update.unbind(1))
	armor_slot_button_1.item_selected.connect(update.unbind(1))
	armor_slot_button_2.item_selected.connect(update.unbind(1))

func _set_character_data(new_value:CharacterData):
	character_data = new_value
	
	if not is_node_ready():
		await ready
	
	update()

func update():
	if character_data:
		name_label.text = character_data.full_name
		class_label.text = character_data.get_character_class_name()
		portrait.texture = character_data.portrait
		
		var total_hp = character_data.get_modified_hp()
		hp_label.text = str(total_hp) + " HP"
		hp_label.label_settings.font_color = Color.WHITE
		if total_hp > character_data.hp:
			hp_label.label_settings.font_color = Color.GREEN
		if total_hp < character_data.hp:
			hp_label.label_settings.font_color = Color.RED
		
		var total_attack = character_data.get_modified_attack()
		attack_label.text = str(total_attack) + " Attack"
		attack_label.label_settings.font_color = Color.WHITE
		if total_attack > character_data.attack:
			attack_label.label_settings.font_color = Color.GREEN
		if total_attack < character_data.attack:
			attack_label.label_settings.font_color = Color.RED
		
		var total_power = character_data.get_modified_power()
		power_label.text = str(total_power) + " Power"
		power_label.label_settings.font_color = Color.WHITE
		if total_power > character_data.power:
			power_label.label_settings.font_color = Color.GREEN
		if total_power < character_data.power:
			power_label.label_settings.font_color = Color.RED
		
		var total_defense = character_data.get_modified_defense()
		defense_label.text = str(total_defense) + " Defense"
		defense_label.label_settings.font_color = Color.WHITE
		if total_defense > character_data.defense:
			defense_label.label_settings.font_color = Color.GREEN
		if total_defense < character_data.defense:
			defense_label.label_settings.font_color = Color.RED
		
		#power_label.text = str(character_data.get_modified_power()) + " Power"
		#defense_label.text = str(character_data.get_modified_attack()) + " Defense"
		
		weapon_slot_button.character_data = character_data
		armor_slot_button_1.character_data = character_data
		armor_slot_button_2.character_data = character_data

func _on_character_data_changed():
	update()
