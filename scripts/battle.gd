extends Node2D
class_name Battle

const PLAYER_COMBATANT_SCENE:PackedScene = preload("uid://bxer6od4tbb5u")

const PLAYER_COMBATANT_SCENES:Dictionary[CharacterData.CharacterClass, PackedScene] = {
	CharacterData.CharacterClass.Fighter: preload("uid://cp4qgoq7tn0qs"),
	CharacterData.CharacterClass.Mage: preload("uid://cfd1xilmm2jxe"),
	CharacterData.CharacterClass.Bard: preload("uid://d517xgtrplrt")
}

static var instance:Battle

signal battle_finished(won:bool)

signal turn_started(combatant:Combatant)
signal turn_ended(combatant:Combatant)

@onready var background:Sprite2D = %Background

@warning_ignore("unused_signal")
signal combatant_clicked(combatant:Combatant)

@export var combatants:Array[Combatant]

@export var player_slots:Array[Node2D]

@export var enemy_slots:Array[Node2D]

@export var enemy_pool:Array[PackedScene]

@export var battle_backgrounds:Array[Texture]

var current_turn_index:int = 0

var waves:int = waves_left
var waves_left:int = 1

var casualties:Array[PlayerCombatant]

var lost_items:Array[ItemData]

var targeting_mode:Ability.TargetMode = Ability.TargetMode.None

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	
	background.texture = battle_backgrounds.pick_random()
	
	waves_left = floori((TimeManager.successful_adventures + 1) / 3.0) + 1
	waves = waves_left
	
	for i in range(min(Globals.hired_characters.size(), 3)):
		var character = Globals.hired_characters[i]
		var slot = player_slots[i]
		var combatant:PlayerCombatant = PLAYER_COMBATANT_SCENES[character.character_class].instantiate()
		combatant.character_data = character
		slot.add_child(combatant)
		combatants.append(combatant)
	
	advance_wave()

func start_battle():
	if combatants.size() == 0:
		return
	
	for combatant in combatants:
		combatant.combatant_defeated.connect(
			func():
				if combatants.has(combatant):
					var index = combatants.find(combatant)
					if current_turn_index >= index:
						current_turn_index -= 1
					
					if combatant is PlayerCombatant:
						casualties.append(combatant)
						for item in combatant.character_data.items.values():
							combatant.character_data.unequip_item(item)
							lost_items.append(item)
					
					combatants.erase(combatant)
					
					if current_turn_index >= combatants.size():
						current_turn_index = 0
		)
	
	current_turn_index = 0
	handle_current_turn()

func handle_current_turn():
	if combatants.size() == 0:
		return
	
	var has_player:bool = false
	var has_enemy:bool = false
	for combatant in combatants:
		if combatant is PlayerCombatant:
			has_player = true
		else:
			has_enemy = true
	
	if not has_player:
		lose_battle()
		return
	
	if not has_enemy:
		win_battle()
		return
	
	var current_combatant:Combatant = combatants[current_turn_index]
	current_combatant.turn_finished.connect(current_turn_finished, CONNECT_ONE_SHOT)
	current_combatant.start_turn()
	turn_started.emit(current_combatant)

func current_turn_finished():
	turn_ended.emit(combatants[current_turn_index])
	
	await get_tree().create_timer(1).timeout
	
	current_turn_index += 1
	if current_turn_index >= combatants.size():
		current_turn_index = 0
	
	handle_current_turn()

func lose_battle():
	battle_finished.emit(false)

func win_battle():
	waves_left -= 1
	
	if waves_left <= 0:
		battle_finished.emit(true)
	else:
		await Fade.fade_out(0.5).finished
		advance_wave()

func advance_wave():
	#var num_enemies = randi_range(max(existing_combatants.size(), 2), enemy_slots.size())
	var num_enemies = randi_range(1, 2)
	
	if TimeManager.successful_adventures >= 1:
		num_enemies = randi_range(2, 3)
		#num_enemies = randi_range(max(combatants.size(), 2), enemy_slots.size())
		if TimeManager.successful_adventures >= 3:
			num_enemies = randi_range(3, 4)
	
	
	for i in range(num_enemies):
		var slot = enemy_slots[i]
		var combatant:Combatant = enemy_pool.pick_random().instantiate()
		slot.add_child(combatant)
		combatants.append(combatant)
	
	await Fade.fade_in(0.5).finished
	
	start_battle()
