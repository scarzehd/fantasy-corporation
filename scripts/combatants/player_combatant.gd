extends Combatant
class_name PlayerCombatant

@export var name_label:Label

@export var character_data:CharacterData : set = _set_character_data

@export var abilities:Array[Ability]

@export var idle_animation:StringName = "idle"	

@export var attack_animation:StringName

@onready var animation_player:AnimationPlayer = %AnimationPlayer

@onready var head:Sprite2D = %Head

func _ready() -> void:
	super()
	
	for ability in abilities:
		ability.combatant = self
	
	animation_player.seek(randf_range(0, 0.25))

func end_turn():
	super()
	animation_player.queue(idle_animation)

func _get_hp() -> int:
	return character_data.get_modified_hp()

func _get_attack() -> int:
	var total_attack = character_data.get_modified_attack()
	
	for effect in status_effects:
		total_attack += effect.attack
	
	return max(1, total_attack)

func _get_power() -> int:
	var total_power = character_data.get_modified_power()
	
	for effect in status_effects:
		total_power += effect.power
	
	return max(1, total_power)

func _get_defense() -> int:
	var total_defense = character_data.get_modified_defense()
	
	for effect in status_effects:
		total_defense += effect.defense
	
	return max(1, total_defense)

func _get_combatant_name() -> String:
	return character_data.full_name

func _set_combatant_name(_new_value:String):
	pass

func _get_portrait() -> Texture:
	return character_data.portrait

func _set_portrait(_new_value:Texture):
	pass

func _set_character_data(new_value:CharacterData):
	character_data = new_value
	
	base_hp = new_value.hp
	base_attack = new_value.attack
	base_defense = new_value.defense
	base_power = new_value.power
	
	if not is_node_ready():
		await ready
	
	name_label.text = character_data.full_name
	
	head.texture = new_value.head

func _on_defeat():
	super()
