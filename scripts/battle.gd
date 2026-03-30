extends Node2D
class_name Battle

static var instance:Battle

#signal battle_finished(won:bool)

signal turn_started(combatant:Combatant)
signal turn_ended(combatant:Combatant)

@warning_ignore("unused_signal")
signal combatant_clicked(combatant:Combatant)

@export var combatants:Array[Combatant]
var current_turn_index:int = 0

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	start_battle()

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
					
					combatants.erase(combatant)
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
	
	current_turn_index += 1
	if current_turn_index >= combatants.size():
		current_turn_index = 0
	
	handle_current_turn()

func lose_battle():
	get_tree().quit()

func win_battle():
	print("A winner is you")
