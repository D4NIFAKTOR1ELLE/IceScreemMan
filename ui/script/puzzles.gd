extends CanvasLayer

@onready var sliding_puzzle = preload("res://game/MinigameSlidingPuzzle.tscn")
@onready var fuse_puzzle = preload("res://game/MinigameFuses.tscn")
@onready var whack_a_mole_puzzle = preload("res://game/MinigameWhackAMole.tscn")
@onready var panel: PanelContainer = $PanelContainer

var puzzles: Array
var current_puzzle: Node = null

func initialise():
	puzzles = [sliding_puzzle, fuse_puzzle, whack_a_mole_puzzle]
	puzzles.shuffle()
	
	choose()
	
func choose():
	current_puzzle = puzzles.pop_back().instantiate()
	current_puzzle.puzzle_solved.connect(on_puzzle_beaten)
	
	panel.add_child(current_puzzle)
	
func on_puzzle_beaten():
	Constants.puzzles_until_win -= 1
	
	if Constants.puzzles_until_win == 0:
		Game.win()
		return

	current_puzzle.queue_free()

	choose()

func _on_visibility_changed() -> void:
	if visible:
		panel.show()
		panel.get_child(0).show()
		panel.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		panel.hide()
		panel.get_child(0).hide()
		panel.process_mode = Node.PROCESS_MODE_DISABLED
