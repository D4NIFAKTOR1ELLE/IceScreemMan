extends CanvasLayer

@onready var flavours: Array[Button] = []
@onready var sanity_overlay = $Control/SanityOverlay
@onready var sanity_bar = $Control/SanityOverlay/ProgressBar

func initialise(flavour_array: Array[String]):
	var index: int = 0
	
	for flavour in range(5):
		var new_button = $Control/Flavours/TextureButton.duplicate()
		$Control/Flavours.add_child(new_button)
	
	for button in $Control/Flavours.get_children():
		button.name = flavour_array[index]
		button.self_modulate = Constants.flavours.get(flavour_array[index])
		button.connect("pressed", _on_flavour_pressed.bind(button))
		index = index + 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_engine"):
		_on_engine_pressed()

func _on_engine_pressed() -> void:
	Game.puzzle_window.visible = !Game.puzzle_window.visible

func _on_ignition_pressed() -> void:
	pass # Replace with function body.

func _on_flavour_pressed(flavour_name: Node):
	if Constants.new_cone:
		Constants.new_cone.add_scoop(flavour_name)

func _on_cone_button_pressed() -> void:
	Constants.new_cone = Constants.cone.instantiate()

	$Control.add_child(Constants.new_cone)
	
	Constants.new_cone.initialise()
	Constants.cone_in_hand = true
