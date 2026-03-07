extends Node

const easy_range: Vector2i = Vector2i(1, 2)
const mid_range: Vector2i = Vector2i(2, 4)
const hard_range: Vector2i = Vector2i(3, 6)

const scoop_limit: int = 6

var cone = preload("res://game/elements/Cone.tscn")
var zombie_preload: PackedScene = preload("res://game/elements/Zombie.tscn")

var max_sanity: int = 4
var sanity: int
var cone_in_hand: bool = false
var game_instance: Game
var puzzles_until_win: int = 3

var flavour_selection: Array[String]
var current_flavour_roster: Array[String] = []

func reset_game():
	Game.zombietimer.stop()
	Game.gametimer.stop()
	
	flavour_selection.assign(flavours.keys())
	
	current_flavour_roster.clear()
	pick_flavours()

	sanity = max_sanity
	puzzles_until_win = 3
	
func pick_flavours():
	var new_flavours: Array[String] = flavour_selection.duplicate()
	new_flavours.shuffle()
	
	for i in range(6):
		current_flavour_roster.append(new_flavours.pop_back())

var flavours: Dictionary = {
	"Pickles": Color.LIGHT_GREEN,
	"Bull Red": Color.LIGHT_CORAL,
	"Vanilla": Color.ANTIQUE_WHITE,
	"Hazelnut": Color.BURLYWOOD,
	"Caramel Squirrels": Color.SADDLE_BROWN,
	"Lemon Drop": Color.YELLOW,
	"Red Blueberry": Color.ORANGE_RED,
	"Blue Strawberry": Color.MIDNIGHT_BLUE,
	"Lime Lizard": Color.CHARTREUSE,
	"Cobble Stone Crunch": Color.DIM_GRAY,
	"Laughing Lavender": Color.SLATE_BLUE,
	"Purple Pineapple": Color.INDIGO,
	"Lickable Llama": Color.PERU,
	"OMG Orange": Color.ORANGE,
	"Dryer Lint": Color.GRAY,
	"Milk Cream": Color.CORNFLOWER_BLUE,
	"Pasta Al Dente": Color.LIGHT_YELLOW,
	"Bubblegum Blast": Color.DEEP_PINK
}
