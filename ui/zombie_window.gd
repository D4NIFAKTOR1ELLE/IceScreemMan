extends CanvasLayer

@onready var zombie_container: HBoxContainer = $Zombies

var zombie_amount: int = 0

func spawn_zombie():
	if zombie_amount >= 3:
		return
	
	var new_zombie = Constants.zombie_preload.instantiate()
	
	zombie_amount = zombie_amount + 1
	zombie_container.add_child(new_zombie)
