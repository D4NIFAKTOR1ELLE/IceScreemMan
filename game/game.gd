extends CanvasLayer

@onready var gametimer: Timer = $GameTimer
@onready var zombietimer: Timer = $ZombieTimer

@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time
@onready var truck_inside: CanvasLayer = $TruckInside
@onready var zombie_window: Control = $TruckInside/Control/ZombieWindow
@onready var puzzle_window: CanvasLayer = $Puzzles

@onready var start_screen := preload("res://ui/MainMenu.tscn")
@onready var result_screen := preload("res://ui/ResultScreen.tscn")
@onready var win_screen := preload("res://ui/Win_Screen.tscn")
@onready var lose_screen := preload("res://ui/Lose_Screen.tscn")

func launch_game():
	await Constants.reset_game()
	
	truck_inside.initialise()
	puzzle_window.initialise()
	zombie_window.initialise()
	
	zombietimer.start()
	gametimer.start()

func win():
	truck_inside.set_process_input(false)
	gametimer.paused = true
	zombietimer.stop()
	puzzle_window.hide()
	
	for zombie in zombie_window.zombie_container.get_children():
		zombie.queue_free()

	Transition.fade_in(2)
	await Transition.transition_anim.animation_finished

	var new_result_screen = result_screen.instantiate()
	await new_result_screen.load_data()
	get_tree().change_scene_to_node(new_result_screen)

	Transition.fade_out(0.5)

func lose():
	truck_inside.set_process_input(false)
	gametimer.stop()
	zombietimer.stop()
	puzzle_window.hide()
	
	Transition.fade_in(2)
	await Transition.transition_anim.animation_finished
	
	for zombie in zombie_window.zombie_container.get_children():
		zombie.queue_free()
	
	get_tree().change_scene_to_node(lose_screen.instantiate())

	Transition.fade_out(0.5)

func _on_game_timer_timeout() -> void:
	await lose()

func _on_zombie_timer_timeout() -> void:
	zombie_window.spawn_zombie()
	
	zombietimer.start()

func _process(_delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
