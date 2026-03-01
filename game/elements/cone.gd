extends Control

class_name Cone

var scoops: int = 0
@onready var start_scoop = $"Scoops/0"

func initialise():
	set_physics_process(true)
	
func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func add_scoop(colour: Color):
	if scoops == 6:
		return
	scoops = scoops + 1
	var new_scoop = start_scoop.duplicate()
	new_scoop.name = str(scoops)
	
	new_scoop.self_modulate = colour
	new_scoop.visible = true
	$Scoops.add_child(new_scoop)
	new_scoop.position = Vector2(start_scoop.position.x, get_node("Scoops/%s" % str(scoops - 1)).position.y - 30)

func remove_scoop():
	if scoops == 0:
		delete()
	
	get_node("Scoops/%s" % str(scoops)).queue_free()
	scoops = scoops - 1

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		delete()

func delete():
	if scoops > 0:
		remove_scoop()
	else:
		self.queue_free()
