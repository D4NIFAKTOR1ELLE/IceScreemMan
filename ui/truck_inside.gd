extends CanvasLayer


func _on_engine_pressed() -> void:
	pass # Replace with function body.

func _on_ignition_pressed() -> void:
	pass # Replace with function body.

func _on_cone_button_pressed() -> void:
	var new_cone = Constants.cone.instantiate()

	Constants.game_instance.get_node("TruckInside").add_child.call_deferred(new_cone)
