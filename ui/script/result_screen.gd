extends CanvasLayer

func load_data():
	$TextureRect/MarginContainer/VBoxContainer/SanityContainer/Score.text = "%d / %d" % [Constants.sanity, Constants.max_sanity] 
	$TextureRect/MarginContainer/VBoxContainer/TimerContainer/Score.text = "%02d:%02d" % [Game.gametimer.time_left / 60, fmod(Game.gametimer.time_left, 60)]

func _on_button_pressed() -> void:
	Transition.fade_in()
	await Transition.transition_anim.animation_finished
	
	get_tree().change_scene_to_node(Game.win_screen.instantiate())

	Transition.fade_out()
