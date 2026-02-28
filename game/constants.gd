extends Node

const easy_range: Vector2i = Vector2i(1, 2)
const mid_range: Vector2i = Vector2i(2, 4)
const hard_range: Vector2i = Vector2i(3, 6)

var flavours: Dictionary = {
	"Pickles": Color.LIGHT_GREEN,
	"Bull Red": Color.ORANGE,
	"Vanilla": Color.ANTIQUE_WHITE,
	"Hazelnut": Color.ROSY_BROWN,
	"Caramel Squirrel": Color.SADDLE_BROWN,
	"Lemon Drop": Color.YELLOW,
	"Red Blueberry": Color.ORANGE_RED,
	"Blue Strawberry": Color.MIDNIGHT_BLUE
}

var flavour_selection: Array[String] = [
	"Pickles", 
	"Bull Red",
	"Vanilla",
	"Hazelnut",
	"Caramel Squirrel",
	"Lemon Drop",
	"Red Blueberry",
	"Blue Strawberry"]
