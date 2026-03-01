extends Node

const easy_range: Vector2i = Vector2i(1, 2)
const mid_range: Vector2i = Vector2i(2, 4)
const hard_range: Vector2i = Vector2i(3, 6)

const scoop_limit: int = 6

var cone = preload("res://game/elements/Cone.tscn")
var zombie_preload: PackedScene = preload("res://game/elements/Zombie.tscn")

var max_sanity: int = 4
var sanity: int
var new_cone: Cone
var cone_in_hand: bool = false
var game_instance: Game
var puzzles_until_win: int = 3


var flavours: Dictionary = {
	"Pickles": Color.LIGHT_GREEN,
	"Bull Red": Color.LIGHT_CORAL,
	"Vanilla": Color.ANTIQUE_WHITE,
	"Hazelnut": Color.ROSY_BROWN,
	"Caramel Squirrel": Color.SADDLE_BROWN,
	"Lemon Drop": Color.YELLOW,
	"Red Blueberry": Color.ORANGE_RED,
	"Blue Strawberry": Color.MIDNIGHT_BLUE,
	"Lime Lizard": Color.CHARTREUSE,
	"Cobble Stone Crunch": Color.DIM_GRAY,
	"Laughing Lavender": Color.SLATE_BLUE,
	"Purple Pineapple": Color.INDIGO,
	"Lickable Llama": Color.PERU,
	"OMG Orange": Color.ORANGE
}

var flavour_selection: Array[String] = [
	"Pickles", 
	"Bull Red",
	"Vanilla",
	"Hazelnut",
	"Caramel Squirrel",
	"Lemon Drop",
	"Red Blueberry",
	"Blue Strawberry",
	"Lime Lizard",
	"Cobble Stone Crunch",
	"Laughing Lavender",
	"Purple Pineapple",
	"Lickable Llama",
	"OMG Orange"]
