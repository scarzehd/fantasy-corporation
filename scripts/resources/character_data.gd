extends Resource
class_name CharacterData

enum CharacterClass {
	Fighter,
	Mage
}

# I separated these out because I thought we might be short on space in the combat section.
# In that case, we could show only the first name.
@export var first_name:String = "John"
@export var last_name:String = "Smith"

@export var power:int = 100
@export var defense:int = 50
@export var hp:int = 100
@export var portrait:Texture2D
@export var character_class:CharacterClass
