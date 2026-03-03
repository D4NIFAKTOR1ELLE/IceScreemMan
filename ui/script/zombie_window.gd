extends Control

@onready var zombie_container: Container = $TextureRect2/Zombies

var zombie_amount: int = 0

func spawn_zombie():
	if zombie_amount >= 3:
		return
	
	var new_zombie = Constants.zombie_preload.instantiate()
	new_zombie.left.connect(_on_zombie_left)
	
	zombie_amount = zombie_amount + 1
	zombie_container.add_child(new_zombie)

func _on_zombie_left():
	zombie_amount -= 1
