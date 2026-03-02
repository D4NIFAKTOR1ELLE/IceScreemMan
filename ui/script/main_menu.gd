extends CanvasLayer

func _ready() -> void:
	Game.truck_inside.set_process_input(false)

func _onStartstory_button_pressed() -> void:
	Transition.fade_in(3)
	await Transition.transition_anim.animation_finished
	
	get_tree().change_scene_to_node(load("res://game/elements/Story.tscn").instantiate())

func _on_startnostory_pressed() -> void:
	Transition.fade_in(3)
	await Transition.transition_anim.animation_finished
	
	Transition.fade_out()

	Game.launch_game()
	
	queue_free()

func _on_exit_pressed() -> void:
	get_tree().quit()
	
