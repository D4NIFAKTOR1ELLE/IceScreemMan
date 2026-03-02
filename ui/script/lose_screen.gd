extends CanvasLayer

func _on_button_pressed() -> void:
	get_tree().change_scene_to_node(Game.start_screen.instantiate())
