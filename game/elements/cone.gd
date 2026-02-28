extends Sprite2D

func initialise():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		pass
	if Input.is_action_just_pressed("right_click"):
		attempt_delete()

func attempt_delete():
	#TODO This'll check if the cone is full before deleting itself
	self.queue_free()
