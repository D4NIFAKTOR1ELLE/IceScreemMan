extends Node2D

signal puzzle_solved

@export var target_score: int = 20

@export var spawn_interval: float = 0.5

@onready var spawn_timer = $SpawnTimer

var score: int = 0

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
			attempt_strike(event.position)

func attempt_strike(click_pos):
	var holes = get_tree().get_nodes_in_group("holes")
	for hole in holes:
		if hole.is_vulnerable:
			if hole.global_position.distance_to(click_pos) < 50:
				hole.handle_hit()
				score += 1
				print("Current Score: ", score)
				if score >= target_score:
					win_game()
				return 


func _on_spawn_timer_timeout():
	var holes = get_tree().get_nodes_in_group("holes")
	if holes.size() > 0:
		var random_hole = holes[randi() % holes.size()]
		random_hole.spawn_zombie()
	

func win_game():
	spawn_timer.stop()
	print("Victory, all zombies have been bonked!")


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
