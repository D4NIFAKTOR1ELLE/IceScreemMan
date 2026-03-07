extends CanvasLayer

@onready var sliding_puzzle = preload("res://game/MinigameSlidingPuzzle.tscn")
@onready var fuse_puzzle = preload("res://game/MinigameFuses.tscn")
@onready var whack_a_mole_puzzle = preload("res://game/MinigameWhackAMole.tscn")
@onready var panel: PanelContainer = $PanelContainer

var puzzles: Array
var current_puzzle: Node = null

func initialise():
	for child in panel.get_children():
		child.free()
	
	puzzles = [sliding_puzzle, fuse_puzzle, whack_a_mole_puzzle]
	puzzles.shuffle()
	
	choose()
	
func choose():
	current_puzzle = puzzles.pop_back().instantiate()
	current_puzzle.puzzle_solved.connect(on_puzzle_beaten)
	
	panel.add_child(current_puzzle)
	
func on_puzzle_beaten():
	$AudioStreamPlayer.play()
	
	hide()
	
	Constants.puzzles_until_win -= 1
	Game.truck_inside.parts_repaired.bbcode_text = "%d / 3" % (3 - Constants.puzzles_until_win)
	
	if Constants.puzzles_until_win == 0:
		await get_tree().create_timer(1).timeout
		$AudioStreamPlayer.stream = load("res://assets/se/freesound_community-carengine-5998.mp3")
		$AudioStreamPlayer.play()
		Game.win()
		if panel.get_child(0):
			panel.get_child(0).queue_free()
		return

	current_puzzle.queue_free()

	choose()

func _on_visibility_changed() -> void:
	if visible:
		panel.show()
		if panel.get_child(0):
			panel.get_child(0).show()
		panel.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		panel.hide()
		if panel.get_child(0):
			panel.get_child(0).hide()
		panel.process_mode = Node.PROCESS_MODE_DISABLED

func _on_exit_button_pressed() -> void:
	hide()
