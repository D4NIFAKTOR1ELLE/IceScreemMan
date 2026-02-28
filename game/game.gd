extends Node

@onready var gametimer: Timer = $GameTimer
@onready var music: AudioStreamPlayer = $Music
@onready var timer_text: Label = $TruckInside/Control/Time

func _ready() -> void:
	print("Game launched!")
	
	gametimer.start()

func lose():
	pass
	
func win():
	pass

func _on_game_timer_timeout() -> void:
	lose()

func _process(delta: float) -> void:
	timer_text.set_text("%02d:%02d" % [gametimer.time_left / 60, fmod(gametimer.time_left, 60)])
