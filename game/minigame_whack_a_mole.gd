extends Control

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
		
		hole.whacked.connect(attempt_strike)

func attempt_strike():
	score += 1
	print("Current Score: ", score)
	if score >= target_score:
		win_game()
	return 

func _on_spawn_timer_timeout():
	var random_hole = holes[randi() % holes.size()]
	random_hole.spawn_zombie()

func win_game():
	spawn_timer.stop()
	print("Victory, all zombies have been bonked!")
	puzzle_solved.emit()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
