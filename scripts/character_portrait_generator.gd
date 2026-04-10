extends SubViewport
class_name CharacterPortraitGenerator

signal finished_generating(character_data:CharacterData)

@onready var body:Sprite2D = %Body
@onready var head:Sprite2D = %Head

const BODIES:Dictionary[CharacterData.CharacterClass, Texture2D] = {
	CharacterData.CharacterClass.Fighter: preload("uid://d0gbjvwmvxety"),
	CharacterData.CharacterClass.Bard: preload("uid://ubomikjr1mdc"),
	CharacterData.CharacterClass.Mage: preload("uid://cmdeyo5h24b7q")
}

func set_portrait(character_data:CharacterData):
	body.texture = BODIES[character_data.character_class]
	head.texture = character_data.head
	
	await RenderingServer.frame_post_draw
	
	character_data.portrait = ImageTexture.create_from_image(get_texture().get_image())
	
	finished_generating.emit(character_data)
