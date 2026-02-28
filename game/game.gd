extends Node

@onready var gametimer: Timer = $GameTimer
@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time

var current_flavour_roster: Array[String] = []

func _ready() -> void:
	print("Game launched!")
	current_flavour_roster.clear()
	
	pick_flavours()
	
	gametimer.start()

func pick_flavours():
	var flavours: Array[String] = Constants.flavour_selection.duplicate()
	flavours.shuffle()
	
	for i in range(6):
		current_flavour_roster.append(flavours.pop_back())
	
	print(current_flavour_roster)

func lose():
	pass
	
func win():
	pass

func _on_game_timer_timeout() -> void:
	lose()

func _process(_delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
