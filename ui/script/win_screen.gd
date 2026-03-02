extends CanvasLayer

func _on_button_pressed() -> void:
	Transition.fade_in()
	await Transition.transition_anim.animation_finished

	get_tree().change_scene_to_node(Game.start_screen.instantiate())

	Transition.fade_out()
