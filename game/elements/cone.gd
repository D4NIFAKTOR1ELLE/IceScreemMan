extends Control

class_name Cone

@onready var start_scoop = $"Scoops/0"

var scoops: int = 0
var flavours_in_scoop: Array[String] = []

func initialise():
	set_physics_process(true)
	
func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func add_scoop(flavour: Node):
	if scoops == 6:
		return

	scoops = scoops + 1
	var new_scoop = start_scoop.duplicate()
	new_scoop.name = str(scoops)
	
	new_scoop.self_modulate = Constants.flavours.get(flavour.name)
	new_scoop.visible = true
	flavours_in_scoop.append(flavour.name)
	print(flavours_in_scoop)
	$Scoops.add_child(new_scoop)
	new_scoop.position = Vector2(start_scoop.position.x, get_node("Scoops/%s" % str(scoops - 1)).position.y - 30)

func remove_scoop():
	if scoops == 0:
		delete()
	
	flavours_in_scoop.pop_back()
	print(flavours_in_scoop)
	
	get_node("Scoops/%s" % str(scoops)).queue_free()
	scoops = scoops - 1

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		delete()

func delete():
	if scoops > 0:
		remove_scoop()
	else:
		flavours_in_scoop.clear()
		self.queue_free()
