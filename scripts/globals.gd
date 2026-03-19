extends Node

var day_number:int = 1

func _ready() -> void:
	hired_characters.append(load("res://resources/character_data/john_smith.tres"))
	hired_characters.append(load("res://resources/character_data/jane_doe.tres"))

# Fill this in here for testing
var hired_characters:Array[CharacterData]
