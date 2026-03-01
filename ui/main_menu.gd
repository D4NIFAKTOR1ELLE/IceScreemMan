extends CanvasLayer

func _onStartstory_button_pressed() -> void:
	pass # Replace with function body.


func _on_startnostory_pressed() -> void:
	Game.launch_game()
	
	queue_free()


func _on_exit_pressed() -> void:
	get_tree().quit()
	
