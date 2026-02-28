extends CanvasLayer

@onready var sliding_puzzle = preload("res://game/SlidingPuzzle.tscn")
@onready var key_puzzle


var puzzles: Array = [sliding_puzzle, key_puzzle]
var current_puzzle: Node = null

func initialise():
	puzzles.shuffle()
	

func choose():
	#TODO Replace pick_random with an index from 1 to 3 or any number
	current_puzzle = puzzles.pick_random()
	
func on_puzzle_beaten():
	Constants.puzzles_until_win -= 1
	
	if Constants.puzzles_until_win == 0:
		Constants.game_instance.win()
