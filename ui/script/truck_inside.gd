extends CanvasLayer

@onready var flavours: Array[Button] = []
@onready var sanity_overlay = $Control/SanityOverlay
@onready var sanity_bar = $Control/SanityOverlay/ProgressBar
@onready var flavour_button = preload("res://ui/FlavourContainer.tscn")
@onready var parts_repaired = $PartsRepaired

var new_cone: Cone

func initialise():
	if new_cone:
		new_cone.free()
		
	var flavour_array = Constants.current_flavour_roster
	
	var index: int = 0
	
	for child in $Control/Flavours.get_children():
		child.free()
	
	for flavour in range(6):
		var new_button = flavour_button.instantiate()
		$Control/Flavours.add_child(new_button)
	
	for button in $Control/Flavours.get_children():
		button.name = flavour_array[index]
		button.get_node("Label").text = button.name
		button.self_modulate = Constants.flavours.get(flavour_array[index])
		button.connect("pressed", _on_flavour_pressed.bind(button))
		index = index + 1

	parts_repaired.text = "0 / 3"
	sanity_overlay.size.x = 70 * Constants.max_sanity
	sanity_bar.max_value = Constants.max_sanity
	sanity_bar.value = Constants.max_sanity
	sanity_bar.size = sanity_overlay.size 
	
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_engine"):
		_on_engine_pressed()

func _on_engine_pressed() -> void:
	Game.puzzle_window.visible = !Game.puzzle_window.visible

func _on_flavour_pressed(flavour_name: Node):
	if new_cone:
		new_cone.add_scoop(flavour_name)

func _on_cone_button_pressed() -> void:
	Constants.cone_in_hand = true
	new_cone = Constants.cone.instantiate()

	$Control.add_child(new_cone)
	
	new_cone.initialise()
