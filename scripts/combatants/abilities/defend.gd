extends TextureButton
class_name DefendAbility

@export var combatant:PlayerCombatant

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	var defend_effect:StatusEffect = StatusEffect.new()
	defend_effect.defense = ceili(combatant.base_defense * 0.5)
	defend_effect.has_duration = true
	defend_effect.duration = 1
	combatant.add_status_effect(defend_effect)
	combatant.end_turn()
