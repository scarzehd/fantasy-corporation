extends Area2D
class_name Combatant

signal turn_finished
signal combatant_defeated

@export var combatant_name:String : set = _set_combatant_name, get = _get_combatant_name
@export var portrait:Texture : set = _set_portrait, get = _get_portrait

var current_hp:int = 1 : set = _set_current_hp

var max_hp:int : get = _get_hp
var attack:int : get = _get_attack
var power:int : get = _get_power
var defense:int : get = _get_defense

@export var health_bar:ProgressBar

@export var base_hp:int
@export var base_attack:int
@export var base_power:int
@export var base_defense:int

var status_effects:Array[StatusEffect]

func _ready() -> void:
	input_event.connect(_on_input_event)
	
	if health_bar:
		health_bar.max_value = max_hp
	
	current_hp = max_hp

func damage(amount:int):
	create_bounce_text(str(amount), Color.DARK_RED, 40)
	current_hp -= amount

func create_bounce_text(text:String, color:Color = Color.WHITE, size:int = 16) -> BounceText:
	var bounce_text = BounceText.create_bounce_text(text, color, size)
	bounce_text.global_position = global_position
	get_tree().current_scene.add_child(bounce_text)
	return bounce_text

func add_status_effect(status_effect:StatusEffect):
	for status_id in status_effect.exclusive_with:
		if has_status_id(status_id):
			return
	
	if status_effect.refresh_duration:
		for status in find_status_id(status_effect.id):
			if status.duration <= status_effect.duration:
				status.end_status_effect()
	
	status_effects.append(status_effect)
	status_effect.combatant = self
	status_effect.ended.connect(status_effects.erase.bind(status_effect))

func has_status_id(status_id:StringName) -> bool:
	for effect in status_effects:
		if effect.id == status_id:
			return true
	
	return false

func find_status_id(status_id:StringName) -> Array[StatusEffect]:
	var effects:Array[StatusEffect]
	
	for effect in status_effects:
		if effect.id == status_id:
			effects.append(effect)
	
	return effects

func start_turn():
	for status_effect in status_effects:
		status_effect.start_turn()

func end_turn():
	for status_effect in status_effects:
		status_effect.end_turn()
	turn_finished.emit()

func _get_hp() -> int:
	return max(1, base_hp)

func _get_attack() -> int:
	var total_attack = base_attack
	
	for effect in status_effects:
		total_attack += effect.attack
	
	return max(1, total_attack)

func _get_power() -> int:
	var total_power = base_power
	
	for effect in status_effects:
		total_power += effect.power
	
	return max(1, total_power)

func _get_defense() -> int:
	var total_defense = base_defense
	
	for effect in status_effects:
		total_defense += effect.defense
	
	return max(1, total_defense)

func _set_current_hp(new_value):
	current_hp = new_value
	if health_bar:
		health_bar.value = current_hp
	if current_hp <= 0:
		combatant_defeated.emit()

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			Battle.instance.combatant_clicked.emit(self)

func _set_combatant_name(new_value:String):
	combatant_name = new_value

func _get_combatant_name() -> String:
	return combatant_name

func _set_portrait(new_value:Texture):
	portrait = new_value

func _get_portrait() -> Texture:
	return portrait
