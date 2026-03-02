extends Node2D

signal puzzle_solved

@export var target_score: int = 20
@export var spawn_interval: float = 0.5

@onready var spawn_timer = $SpawnTimer
@onready var holes: Array[Area2D]

var score: int = 0

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

	for hole in $Node.get_children():
		holes.append(hole)
		hole.hide()
		hole.whacked.connect(attempt_strike)

func attempt_strike():
	score += 1
	if score >= target_score:
		win_game()
	return 

func _on_spawn_timer_timeout():
	var random_hole = holes[randi() % holes.size()]
	random_hole.spawn_zombie()

func win_game():
	spawn_timer.stop()
	puzzle_solved.emit()

func _on_visibility_changed() -> void:
	if visible:
		for hole in $Node.get_children():
			hole.show()
	else:
		for hole in $Node.get_children():
			hole.hide()
