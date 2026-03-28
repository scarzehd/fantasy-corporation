extends TextureButton
class_name AttackAbility

@export var combatant:PlayerCombatant

func _ready() -> void:
	Battle.instance.combatant_clicked.connect(_on_combatant_clicked)
	if combatant.weapon:
		texture_normal = combatant.weapon.item_portrait

func _on_combatant_clicked(clicked_combatant:Combatant):
	if not button_pressed:
		return
	
	if clicked_combatant is PlayerCombatant:
		return
	
	button_pressed = false
	
	if RandomUtils.roll_attack(clicked_combatant.defense, combatant.attack):
		clicked_combatant.damage(roundi(combatant.power * randf_range(0.9, 1.1)))
	else:
		clicked_combatant.create_bounce_text("MISS", Color.WHITE, 40)
	
	combatant.end_turn()
