extends CanvasLayer

signal transition_finished

@onready var transition_anim = $TransitionPlayer
@onready var screen = $Background

func fade_in(duration: float = 1.0):
	if duration != 1.0:
		transition_anim.play("fade_in", -1, duration)
	else:
		transition_anim.play("fade_in")
	
func fade_out(duration: float = 1.0):
	if duration != 1.0:
		transition_anim.play("fade_out", -1, duration)
	else:
		transition_anim.play("fade_out")

func abrupt_in():
	transition_anim.play("abrupt_in")

func abrupt_out():
	transition_anim.play("abrupt_out")

func _on_transition_player_animation_finished(_anim_name: StringName) -> void:
	transition_finished.emit()
