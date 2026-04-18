extends Resource
class_name StatusEffect

signal ended

@export var id:StringName

@export var name:String

@export var exclusive_with:Array[StringName]

@export var has_duration:bool = false
@export var duration:int = 0
@export var refresh_duration:bool = false

@export var power:int = 0
@export var defense:int = 0
@export var attack:int = 0

@export var damage:int = 0

@export var icon:Texture

@export var negative:bool = true

var combatant:Combatant

func start_turn():
	if damage < 0:
		combatant.heal(-damage)
		
		duration -= 1
		if duration <= 0:
			end_status_effect()

func end_turn():
	if damage >= 0:
		if damage > 0:
			combatant.damage(damage)
		
		if has_duration:
			duration -= 1
			if duration <= 0:
				end_status_effect()

func end_status_effect():
	ended.emit()
	combatant = null
