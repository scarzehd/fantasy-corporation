extends Ability
class_name DefendAbility

const STATUS_ICON = preload("uid://40wrakmuh4mb")

func _button_pressed():
	if combatant.acted:
		return
	
	combatant.acted = true
	
	var defend_effect:StatusEffect = StatusEffect.new()
	defend_effect.id = "defend"
	defend_effect.name = "Defend"
	defend_effect.defense = ceili(combatant.base_defense * 0.5)
	defend_effect.has_duration = true
	defend_effect.duration = 2
	defend_effect.refresh_duration = true
	defend_effect.icon = STATUS_ICON
	combatant.add_status_effect(defend_effect)
	combatant.end_turn()
