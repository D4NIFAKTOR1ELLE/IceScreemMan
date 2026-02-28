extends Node

@onready var gametimer: Timer = $GameTimer
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	print("Game launched!")
	
	gametimer.start()
