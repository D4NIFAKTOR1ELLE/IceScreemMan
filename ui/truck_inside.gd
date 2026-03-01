extends CanvasLayer

@onready var flavours: Array[Button] = []

func initialise(flavour_array: Array[String]):
	var index: int = 0
	
	for button in $Control/Flavours.get_children():
		button.name = flavour_array[index]
		button.self_modulate = Constants.flavours.get(flavour_array[index])
		button.connect("pressed", _on_flavour_pressed.bind(button))
		index = index + 1

func _on_engine_pressed() -> void:
	pass # Replace with function body.

func _on_ignition_pressed() -> void:
	pass # Replace with function body.

func _on_flavour_pressed(flavour_name: Node):
	if Constants.new_cone:
		Constants.new_cone.add_scoop(flavour_name)

func _on_cone_button_pressed() -> void:
	Constants.new_cone = Constants.cone.instantiate()

	$Control.add_child.call_deferred(Constants.new_cone)
	Constants.cone_in_hand = true
