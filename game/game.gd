extends Node

class_name Game

@onready var gametimer: Timer = $GameTimer
@onready var zombietimer: Timer = $ZombieTimer

@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time
@onready var truck_inside: CanvasLayer = $TruckInside
@onready var zombie_window: CanvasLayer = $ZombieWindow
@onready var puzzle_window: CanvasLayer = $Puzzles

var current_flavour_roster: Array[String] = []

func _ready() -> void:
	launch_game()

func launch_game():
	Constants.game_instance = self
	current_flavour_roster.clear()
	
	Constants.sanity = Constants.max_sanity
	truck_inside.sanity_overlay.size.x = 70 * Constants.max_sanity
	truck_inside.sanity_bar.max_value = Constants.max_sanity
	truck_inside.sanity_bar.value = Constants.max_sanity
	truck_inside.sanity_bar.size = truck_inside.sanity_overlay.size 
	puzzle_window.initialise()
	
	await pick_flavours()
	
	gametimer.start()

func pick_flavours():
	var flavours: Array[String] = Constants.flavour_selection.duplicate()
	flavours.shuffle()
	
	for i in range(6):
		current_flavour_roster.append(flavours.pop_back())
	
	truck_inside.initialise(current_flavour_roster)

func win():
	gametimer.stop()
	print("You won!")

func lose():
	gametimer.stop()
	zombietimer.stop()
	print("🤣🤣🤣🫵🫵🫵🫵")

func _on_game_timer_timeout() -> void:
	win()

func _on_zombie_timer_timeout() -> void:
	zombie_window.spawn_zombie()
	
	zombietimer.start()

func _process(_delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
