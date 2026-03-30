extends Combatant
class_name PlayerCombatant

@export var name_label:Label

@export var character_data:CharacterData : set = _set_character_data
@export var weapon:ItemData
@export var armor:Array[ItemData]

func _ready() -> void:
	super()
	
	name_label.text = character_data.full_name

func _get_hp() -> int:
	var hp = base_hp
	
	if weapon:
		hp += weapon.hp
	
	for item in armor:
		hp += item.hp
	
	return max(1, hp)

func _get_attack() -> int:
	var total_attack = base_attack
	
	for effect in status_effects:
		total_attack += effect.attack
	
	if weapon:
		total_attack += weapon.attack
	
	for item in armor:
		total_attack += item.attack
	
	return max(1, total_attack)

func _get_power() -> int:
	var total_power = super()
	
	for effect in status_effects:
		total_power += effect.power
	
	if weapon:
		total_power += weapon.power
	
	for item in armor:
		total_power += item.power
	
	return max(1, total_power)

func _get_defense() -> int:
	var total_defense = base_defense
	
	for effect in status_effects:
		total_defense += effect.defense
	
	if weapon:
		total_defense += weapon.defense
	
	for item in armor:
		total_defense += item.defense
	
	return max(1, total_defense)

func _set_character_data(new_value:CharacterData):
	character_data = new_value
	
	base_hp = new_value.hp
	base_attack = new_value.attack
	base_defense = new_value.defense
	base_power = new_value.power
