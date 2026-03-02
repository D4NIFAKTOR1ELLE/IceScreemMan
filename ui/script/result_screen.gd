extends CanvasLayer

func load_data():
	$TextureRect/MarginContainer/VBoxContainer/SanityContainer/Score.text = "%d / %d" % [Constants.sanity, Constants.max_sanity] 
	$TextureRect/MarginContainer/VBoxContainer/TimerContainer/Score.text = "%02d:%02d" % [Game.gametimer.time_left / 60, fmod(Game.gametimer.time_left, 60)]
	$TextureRect/MarginContainer/VBoxContainer/ScoreContainer/Label3.text = "%d / 3 Rats" % [calculate_stars()]
	update_stars()
	
func update_stars() -> void:
	if calculate_stars() == 1:
		$TextureRect/MarginContainer/VBoxContainer/ZombieContainer/TextureRect2.modulate = Color(0.3, 0.3, 0.3)
		$TextureRect/MarginContainer/VBoxContainer/ZombieContainer/TextureRect3.modulate = Color(0.3, 0.3, 0.3)
	elif calculate_stars() == 2:
		$TextureRect/MarginContainer/VBoxContainer/ZombieContainer/TextureRect3.modulate = Color(0.3, 0.3, 0.3)

func calculate_stars() -> int: # 1 Stern fuer Gewinnen, 1 Stern fuer alle Sanity und 1 Stern fuer mehr als 2 min Zeit left
	var stars = 1
	if Constants.sanity == Constants.max_sanity:
		stars += 1
	if Game.gametimer.time_left > 120:
		stars += 1
	return stars
	
func _on_button_pressed() -> void:
	Transition.fade_in()
	await Transition.transition_anim.animation_finished
	
	get_tree().change_scene_to_node(Game.win_screen.instantiate())

	Transition.fade_out()
