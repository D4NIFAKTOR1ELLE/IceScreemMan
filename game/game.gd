extends Node

class_name Game

@onready var gametimer: Timer = $GameTimer
@onready var zombietimer: Timer = $ZombieTimer

@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time
@onready var truck_inside: CanvasLayer = $TruckInside
@onready var zombie_window: CanvasLayer = $ZombieWindow

var current_flavour_roster: Array[String] = []

func _ready() -> void:
	launch_game()

func launch_game():
	Constants.game_instance = self
	current_flavour_roster.clear()
	
	await pick_flavours()
	
	gametimer.start()

func pick_flavours():
	var flavours: Array[String] = Constants.flavour_selection.duplicate()
	flavours.shuffle()
	
	for i in range(6):
		current_flavour_roster.append(flavours.pop_back())
	
	print(current_flavour_roster)
	truck_inside.initialise(current_flavour_roster)

func win():
	gametimer.stop()
	print("You won!")

func lose():
	gametimer.stop()
	print("🤣🤣🤣🫵🫵🫵🫵")

func _on_game_timer_timeout() -> void:
	win()

func _on_zombie_timer_timeout() -> void:
	zombie_window.spawn_zombie()
	
	zombietimer.start()

func _process(_delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
