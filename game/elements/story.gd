extends CanvasLayer

var next: int = 1

func _ready() -> void:
	set_process_input(false)

	Transition.fade_out(0.5)
	await Transition.transition_finished
	
	set_process_input(true)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("panel_%d" % next)
		next += 1
		await $AnimationPlayer.animation_finished
	
func abrupt_in():
	Transition.abrupt_in()

func launch():
	Game.launch_game()
	
	Transition.fade_out()
	
	self.queue_free()
	
