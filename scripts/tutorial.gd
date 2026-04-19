extends Node2D
class_name Tutorial

static var phase:int = 0

@export var mailbox_button:MailBox
@export var door_button:DoorButton
@export var inventory_button:InventoryMenu
@export var globe_button:GlobeButton

@export var bad_character_data:CharacterData
@export var items:Array[ItemData]
@export var good_character_data:CharacterData
@export var second_items:Array[ItemData]

@export var battle_hud:BattleHUD

# This is awful.
func _ready() -> void:
	if Tutorial.phase == 0:
		phase_0()
	if Tutorial.phase == 1:
		phase_1()

# Can you tell I never make cutscenes?
func phase_0():
	await get_tree().create_timer(1).timeout
	
	var dialogue = TutorialDialogue.create_dialogue(["Welcome to your new job, Manager!", "We're on a tight schedule so let's get started.", "First thing's first. Let's check the mail."], false, false)
	add_child(dialogue)
	
	await dialogue.dialogue_finished
	
	mailbox_button.disabled = false
	
	var newspaper_letter:NewspaperLetter = mailbox_button.NEWSPAPER_LETTER_SCENE.instantiate()
	mailbox_button.letter_container.add_child(newspaper_letter)
	mailbox_button.letters.append(newspaper_letter)
	
	var resume_letter:ResumeLetter = mailbox_button.RESUME_LETTER_SCENE.instantiate()
	resume_letter.character_data = bad_character_data
	mailbox_button.letter_container.add_child(resume_letter)
	mailbox_button.letters.append(resume_letter)
	resume_letter.accept_button.disabled = true
	
	var catalogue:BasicShopCatalogue = mailbox_button.ITEM_CATALOGUE.instantiate()
	mailbox_button.letter_container.add_child(catalogue)
	mailbox_button.letters.append(catalogue)
	catalogue.populate(items)
	
	var item_view:CatalogueItemView = catalogue.item_container.get_child(1)
	
	item_view.purchase_button.disabled = true
	
	await mailbox_button.pressed
	
	mailbox_button.disabled = true
	
	mailbox_button.next_letter_button.hide()
	
	dialogue.close_dialogue()
	
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Here you'll find newspapers detailing the various goings on of the world, adventurer applications, and items available for purchase!", "Looks like today's presses are cold. Go ahead and hit the button on the right to see who's looking for work."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	mailbox_button.next_letter_button.show()
	
	await mailbox_button.next_letter_button.pressed
	
	mailbox_button.next_letter_button.hide()
	mailbox_button.previous_letter_button.hide()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Hmm... Low stats across the board.", "Let's take a look at the item shop."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	mailbox_button.next_letter_button.show()
	
	await mailbox_button.next_letter_button.pressed
	
	mailbox_button.next_letter_button.hide()
	mailbox_button.previous_letter_button.hide()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["The catalogue is a bit light today. I hope Sean hasn't fallen on hard times.", "\"Sonic Hammer\", huh? Good attack, great power, and a secondary HP bonus. And a good price, too. That'll serve us nicely.", "...just as long as you don't tell your party that the effects are mostly placebo. Buy that and we'll be on our way."], false, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	item_view.purchase_button.disabled = false
	
	await item_view.purchase_button.pressed
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["That's all we need from the mail. I'll show you around the rest of the office and then we'll call it a day."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	var mailbox_exit_button = mailbox_button.find_child("CloseButton")
	mailbox_exit_button.disabled = false
	await mailbox_exit_button.pressed
	
	mailbox_exit_button.disabled = true
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Let's bask in the success of our recent transaction, shall we?", "Click on the safe to view, and, if necessary, liquidate your assets."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	inventory_button.disabled = false
	
	await inventory_button.pressed
	
	inventory_button.disabled = true
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["There's that Sonic Hammer. Shiny as the day we bought it.", "Items are worth less used than new, but if you leave them long enough, their value will appreciate over time."], false, true)
	add_child(dialogue)
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Click the exit button and we'll wrap things up."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	var inventory_exit_button = inventory_button.find_child("ExitButton")
	inventory_exit_button.disabled = false
	await inventory_exit_button.pressed
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Well, it's quitting time. I know, time sure does fly here at Fantasy Corp.", "Click on the bell to clock out and I'll see you at 9am tomorrow."], true, false)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	door_button.disabled = false
	
	await door_button.find_child("AcceptButton").pressed
	
	door_button.disabled = true
	
	dialogue.close_dialogue()
	
	Globals.adventurer_price_modifier = 1.5
	Globals.item_price_modifier = 0.75
	
	mailbox_button._on_day_ended()
	mailbox_button._on_confirm_button_pressed()
	
	await get_tree().create_timer(2).timeout
	
	Globals.money -= 50
	
	await get_tree().create_timer(1).timeout
	
	newspaper_letter = mailbox_button.NEWSPAPER_LETTER_SCENE.instantiate()
	mailbox_button.letter_container.add_child(newspaper_letter)
	mailbox_button.letters.append(newspaper_letter)
	
	resume_letter = mailbox_button.RESUME_LETTER_SCENE.instantiate()
	resume_letter.character_data = good_character_data
	mailbox_button.letter_container.add_child(resume_letter)
	mailbox_button.letters.append(resume_letter)
	resume_letter.accept_button.disabled = true
	
	catalogue = mailbox_button.ITEM_CATALOGUE.instantiate()
	mailbox_button.letter_container.add_child(catalogue)
	mailbox_button.letters.append(catalogue)
	catalogue.populate(second_items)
	
	for child in catalogue.item_container.get_children():
		child.purchase_button.disabled = true
	
	get_parent().day_label.text = "Day 2"
	
	dialogue = TutorialDialogue.create_dialogue(["Welcome back! You'll notice in the top left that you've lost some money since yesterday.", "Every day, you'll have to spend some money to keep the business operational. The more days go by, the more you'll have to pay.", "Now, let's take a look at those letters."])
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	mailbox_button.disabled = false
	await mailbox_button.pressed
	
	mailbox_button.disabled = true
	mailbox_button.next_letter_button.hide()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	
	dialogue = TutorialDialogue.create_dialogue(["Hmm. Adventurer price went up and item price went down.", "Let's hope we get an applicant worth the expense."])
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	mailbox_button.next_letter_button.show()
	await mailbox_button.next_letter_button.pressed
	mailbox_button.next_letter_button.hide()
	mailbox_button.previous_letter_button.hide()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Jackpot! Good stats all around. Hire Jane and we'll look at the item shop."], true)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	resume_letter.accept_button.disabled = false
	await resume_letter.accept_button.pressed
	
	mailbox_button.next_letter_button.show()
	
	await mailbox_button.next_letter_button.pressed
	
	for child in catalogue.item_container.get_children():
		child.purchase_button.disabled = true
	
	mailbox_button.previous_letter_button.hide()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["I'm not quite sure who Steve is, but it looks like he's got good taste in armor.", "Let's buy these and then exit the mailbox."], true)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	for child in catalogue.item_container.get_children():
		child.purchase_button.disabled = false
	
	for child in catalogue.item_container.get_children():
		child.purchase_button.disabled = false
	
	while Globals.owned_items.size() < 3:
		await get_tree().process_frame
	
	mailbox_exit_button.disabled = false
	await mailbox_exit_button.pressed
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["You can have up to three adventurers in your party at a time. Since you're still in training, one is fine for now.", "It's time you get your hands dirty. And by that I mean watch your employees get their hands dirty on your behalf.", "Click on the globe to start planning your adventure."])
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	globe_button.disabled = false
	await globe_button.pressed
	globe_button.disabled = true
	
	var listing:AdventurerListing
	
	for child in globe_button.adventurer_listing_container.get_children():
		if child is AdventurerListing:
			listing = child
	
	listing.weapon_slot_button.button.disabled = true
	listing.armor_slot_button_1.button.disabled = true
	listing.armor_slot_button_2.button.disabled = true
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Here you can see your party, their equipped items, and their total stats.", "Equip Jane here with the Sonic Hammer and Shirt and Pants of Steve. Then we can head out."])
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	listing.weapon_slot_button.button.disabled = false
	listing.armor_slot_button_1.button.disabled = false
	listing.armor_slot_button_2.button.disabled = false
	
	while good_character_data.items.keys().size() < 3:
		await get_tree().process_frame
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Click on Begin Adventure whenever you're ready."], true)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	globe_button.start_button.disabled = false
	
	Tutorial.phase = 1

func phase_1():
	# This really should be in a separate script, but I want to keep this mess all in one place so I never have to see it again.
	
	# This should never happen but I'm covering my bases
	if not Battle.instance:
		return
	
	await Battle.instance.turn_started
	
	# This is so stupid.
	# But if we don't do this, clicking on the player during targeting fucks up tutorial progression.
	Battle.instance.combatants[0].find_child("CollisionShape2D", true, false).disabled = true
	
	for child in battle_hud.attack_container.get_children():
		if child == battle_hud.attack_button_template:
			continue
		
		child.hide()
		
	var attack_button:TextureButton = battle_hud.attack_container.get_child(1)
	attack_button.show()
	attack_button.disabled = true
	attack_button.modulate = Color(0.25, 0.25, 0.25)
	
	var dialogue = TutorialDialogue.create_dialogue(["The owner of this cave hired us to take care of these little critters.", "They're nothing special. One or two hits should get the job done.", "Click on the Strike ability."], true)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	attack_button.modulate = Color.WHITE
	
	attack_button.disabled = false
	
	await attack_button.toggled
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Now just click on the enemy you want to Strike."], true)
	add_child(dialogue)
	
	await Battle.instance.combatant_clicked
	
	dialogue.close_dialogue()
	
	while true:
		await Battle.instance.turn_started
		if Battle.instance.combatants[Battle.instance.current_turn_index] is PlayerCombatant:
			break
	
	for child in battle_hud.attack_container.get_children():
		if child == battle_hud.attack_button_template:
			continue
		
		child.hide()
		
	attack_button = battle_hud.attack_container.get_child(1)
	attack_button.show()
	attack_button.disabled = true
	attack_button.modulate = Color(0.25, 0.25, 0.25)
	
	dialogue = TutorialDialogue.create_dialogue(["Ouch! Looks like you've been inflicted with a status effect.", "Although Fantasy Corporation is not liable for any injury or death that occurs on our adventures, dead adventurers won't be able to return equipment you've lent them.", "We don't want to lose that Sonic Hammer, now do we?", "One more hit should do the trick."], true)
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	attack_button.disabled = false
	attack_button.modulate = Color.WHITE
	
	await Battle.instance.battle_finished
	
	Globals.owned_items.clear()
	
	dialogue.close_dialogue()
	await dialogue.dialogue_closed
	
	dialogue = TutorialDialogue.create_dialogue(["Congratulations on your success!", "Normally, any surviving adventurers would return their equipped items to you after the adventure. Unfortunately, Sean's Weapon Shop has issued a recall on those items. Something about 'potential copyright issues.'", "As with all adventurers, Jane was only signed with us for the duration of this adventure. Next time, you'll need to construct a whole new party.", "Jane's off to bigger and better things and so are you! You are now a fully fledged Manager here at Fantasy Corp.", "Good luck. You'll need it."])
	add_child(dialogue)
	await dialogue.dialogue_finished
	
	Globals.reset()
