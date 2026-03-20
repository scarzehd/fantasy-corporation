extends Resource
class_name CharacterGenerator

@export var power_range:Vector2i
@export var power_deviation:float = 0.5
@export var defense_range:Vector2i
@export var defense_deviation:float = 0.5
@export var hp_range:Vector2i
@export var hp_deviation:float = 0.5

@export var first_names:Array[String] = [
	"Aaliyah","Abigail","Agatha","Agnes","Aislinn","Alice","Allison","Amanda","Amelia","Anastasia","Andrea","Angela","Antoinette","Aria","Ashley","Ashlyn","Audrey","Augustine","Aurora",
	"Barbara","Beatrix","Bellamy","Bertha","Beverly","Blake","Bonnie","Brandy","Breanna","Bridget","Brittney","Brooke",
	"Camilla","Candace","Caroline","Catherine","Charlotte","Cassandra","Clara","Claudia","Cecilia","Cheryl","Chloe","Christina","Constance","Cordelia","Cynthia",
	"Daisy","Danielle","Daphne","Darcy","Deborah","Denise","Diana","Dolores","Dorothy",
	"Edith","Elaine","Eleanor","Elizabeth","Ella","Elora","Emily","Erin","Ethel","Eva","Evelyn",
	"Fabiana","Faith","Felicity","Fiona","Florence","Francesca","Fredia",
	"Gabrielle","Genevieve","Georgina","Gertrude","Gillian","Grace","Gwendolyn","Gwyneth",
	"Hannah","Harriet","Harper","Helen","Helka","Henrietta","Hilary","Hilda",
	"Irene","Iris","Isabelle","Isidora","Isis","Isolde","Ivy",
	"Jade","Jamie","Jane","Jasmin","Jeanet","Jennifer","Jessica","Johanna","Josephine","Judith","Julia","Juliette",
	"Karen","Karina","Karla","Katrina","Kathleen","Kelly","Kenneally","Kerry","Kimberly","Kristen","Kora","Kylie",
	"Laura","Layla","Leah","Leanna","Leonie","Ligea","Lilly","Linda","Lindsey","Lisa","Lucia","Luna","Lucretia","Lynn",
	"Madison","Magdalen","Marcia","Margaret","Marilyn","Marion","Martha","Mary","Melanie","Melinda","Melissa","Mia","Michelle","Minerva","Miranda","Molly","Morgana",
	"Nadia","Natalie","Natasha","Nanda","Naomi","Nichole","Nina","Nora","Nova","Nuria",
	"Octavia","Olivia","Olga","Opal","Ophelia",
	"Pamela","Patricia","Paula","Pauline","Pearl","Penelope","Philippa","Philomena","Phoebe","Priscilla",
	"Quetzally","Quelynn","Quincey",
	"Rachel","Raegan","Rebecca","Regina","Renata","Rhea","Riley","Rita","River","Roberta","Rosaline","Rose","Roxanne","Ruby","Ruth",
	"Sally","Samantha","Samira","Sandra","Sarah","Scarlet","Selina","Serenity","Sharon","Sheila","Sherry","Sidney","Sinead","Sophia","Stacey","Stella","Stephany","Susan","Sylvia",
	"Talia","Tamara","Tamsin","Tanya","Tara","Tatiana","Taylor","Teresa","Thelma","Theodora","Tiana","Tiffany","Tracy","Trinity","Tristan","Trixie",
	"Una","Ursa","Ursula",
	"Valentina","Valerie","Vanda","Vanessa","Vera","Victoria","Violet","Virginia","Vita","Vivian",
	"Wendy","Wesley","Whitney","Willow",
	"Xanthe","Xena","Xenia","Ximena",
	"Yanna","Yuliana","Yvonne",
	"Zara","Zelda","Zoey", "Aaron","Abraham","Ace","Adam","Adrian","Aiden","Alastair","Albert","Alexander","Alfred","Allan","Alvin","Amadeus","Andrew","Angus","Anthony","Arnold","Arthur","Asher","Austin",
	"Balthazar","Barnaby","Barry","Bartholomew","Basil","Beau","Benjamin","Blake","Boris","Bradley","Brandon","Brenard","Brian","Brock","Bruce","Bruno",
	"Caesar","Caleb","Calvin","Cameron","Carson","Caspian","Chad","Charles","Chase","Chester","Christian","Christopher","Clayton","Clifford","Clinton","Clyde","Collin","Cooper","Cyrus",
	"Damian","Daniel","Darrell","David","Dennis","Derek","Dexter","Diego","Dominic","Donald","Duncan","Dwight","Dylan",
	"Ean","Earl","Eden","Edmond","Edward","Eli","Elijah","Elliot","Emmanuel","Emory","Enoch","Eric","Ethan","Eugene","Ezekiel",
	"Fabian","Felix","Ferdinand","Finn","Fletcher","Franklin","Fredrich",
	"Gabriel","Gary","Geoffery","George","Gerald","Geronimo","Gilbert","Grant","Gregory","Griffin","Griffith","Grover","Gordon","Gustav",
	"Hannibal","Hans","Harold","Harvey","Hector","Henry","Herbert","Herman","Hernest","Homer","Horatio","Howard","Hudson","Hugh",
	"Ian","Isaac","Isaiah","Isidore","Ivan","Ivor",
	"Jack","Jackson","Jacob","James","Jamil","Jason","Jeffrey","Jeremiah","John","Jonas","Jonathan","Joseph","Joshua","Justin",
	"Kane","Kayden","Kenneth","Kevin","Kyle",
	"Laurence","Leonard","Leopold","Lewis","Liam","Lincoln","Logan","Lucas","Lucius","Lyndon",
	"Maddox","Manfred","Marcus","Marshall","Martin","Mathias","Matthew","Mason","Maximilian","Maxwell","Maverick","Michael","Miles","Millard","Morgan","Murphey",
	"Nathanel","Nelson","Nicholas","Nigel","Noah","Norbert","Norman",
	"Oliver","Oscar","Oswald","Owen",
	"Parker","Pascal","Patrick","Paul","Perry","Peter","Percival","Philip",
	"Quasim","Quentin","Quillian",
	"Raphael","Raul","Raymond","Richard","Riley","Rhett","Robert","Roland","Roman","Romeo","Ross","Rowan","Rudi","Rufus","Russell","Ryan",
	"Samuel","Santiago","Sawyer","Scott","Sean","Searge","Sebastian","Simon","Solomon","Spencer","Stanley","Stephen","Steve","Sylvester",
	"Terrence","Theodore","Thomas","Timothy","Tobias","Trevor","Tucker","Tyler","Tyson",
	"Ulysses","Umar","Umberto","Uriah",
	"Valentin","Vance","Vaughn","Victor","Vincent",
	"Walker","Walter","Werner","William","Willis","Wolfgang","Woodrow",
	"Xander","Xanthus","Xavier","Xerxes",
	"Yannis","Young","Yuri",
	"Zachary","Zane","Zebadiah"
]

@export var last_names:Array[String] = [
	"Smith",
	"Stevens",
	"Richguy",
	"Middleman",
	"Knolastname",
	"Franklinson"
]

@export var portraits:Array[Texture2D]

func generate_in_range(lower:int, upper:int, deviation_scale:float) -> int:
	var mean = (upper + lower) / 2.0
	var deviation = (upper - mean) * deviation_scale
	return clamp(roundi(randfn(mean, deviation)), lower, upper)

func generate() -> CharacterData:
	var data = CharacterData.new()
	
	# TODO do this in a less stupid way.
	data.character_class = CharacterData.CharacterClass.Fighter if randf() > 0.5 else CharacterData.CharacterClass.Mage
	
	data.hp = generate_in_range(hp_range.x, hp_range.y, hp_deviation)
	data.power = generate_in_range(power_range.x, power_range.y, power_deviation)
	data.defense = generate_in_range(defense_range.x, defense_range.y, defense_deviation)
	
	data.first_name = first_names.pick_random()
	data.last_name = last_names.pick_random()
	
	data.portrait = portraits.pick_random()
	
	return data
