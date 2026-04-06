extends Ability
class_name DefendAbility

func _button_pressed():
	var defend_effect:StatusEffect = StatusEffect.new()
	defend_effect.defense = ceili(combatant.base_defense * 0.5)
	defend_effect.has_duration = true
	defend_effect.duration = 2
	defend_effect.refresh_duration = true
	combatant.add_status_effect(defend_effect)
	combatant.end_turn()
