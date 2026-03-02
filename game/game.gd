extends CanvasLayer

@onready var gametimer: Timer = $GameTimer
@onready var zombietimer: Timer = $ZombieTimer

@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time
@onready var truck_inside: CanvasLayer = $TruckInside
@onready var zombie_window: CanvasLayer = $ZombieWindow
@onready var puzzle_window: CanvasLayer = $Puzzles

var current_flavour_roster: Array[String] = []

@onready var start_screen := preload("res://ui/MainMenu.tscn")
@onready var result_screen := preload("res://ui/ResultScreen.tscn")
@onready var win_screen := preload("res://ui/Win_Screen.tscn")
@onready var lose_screen := preload("res://ui/Lose_Screen.tscn")

func launch_game():
	current_flavour_roster.clear()
	pick_flavours()
	
	zombie_window.zombie_amount = 0
	Constants.sanity = Constants.max_sanity
	truck_inside.sanity_overlay.size.x = 70 * Constants.max_sanity
	truck_inside.sanity_bar.max_value = Constants.max_sanity
	truck_inside.sanity_bar.value = Constants.max_sanity
	truck_inside.sanity_bar.size = truck_inside.sanity_overlay.size 
	puzzle_window.initialise()
	
	truck_inside.set_process_input(true)
	zombietimer.start()
	gametimer.start()

func pick_flavours():
	var flavours: Array[String] = Constants.flavour_selection.duplicate()
	flavours.shuffle()
	
	for i in range(6):
		current_flavour_roster.append(flavours.pop_back())
	
	truck_inside.initialise(current_flavour_roster)

func win():
	gametimer.stop()
	zombietimer.stop()
	puzzle_window.panel.hide()
	truck_inside.set_process_input(false)
	
	for zombie in zombie_window.zombie_container.get_children():
		zombie.queue_free()

	Transition.fade_in(2)
	await Transition.transition_anim.animation_finished

	var new_result_screen = result_screen.instantiate()
	new_result_screen.load_data()
	get_tree().change_scene_to_node(new_result_screen)

	Transition.fade_out(0.5)

func lose():
	gametimer.stop()
	zombietimer.stop()
	puzzle_window.panel.hide()
	truck_inside.set_process_input(false)
	
	Transition.fade_in(2)
	await Transition.transition_anim.animation_finished
	
	for zombie in zombie_window.zombie_container.get_children():
		zombie.queue_free()
	
	get_tree().change_scene_to_node(lose_screen.instantiate())

	Transition.fade_out(0.5)

func _on_game_timer_timeout() -> void:
	win()

func _on_zombie_timer_timeout() -> void:
	zombie_window.spawn_zombie()
	
	zombietimer.start()

func _process(_delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
