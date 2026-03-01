extends Control

@onready var request: Array = []
@onready var body: TextureRect = $Body

var zombies: Array[String] = [
	"res://assets/art/zombies/zombieBoy.png",
	"res://assets/art/zombies/zombieGirl.png",
	"res://assets/art/zombies/zombieTeen1.png"]

func _ready() -> void:
	body.texture = load(zombies[randi_range(0, 2)])
	body.visible = true

func spawn():
	
	
	for scoop in randi_range(1, 4):
		pass

func punch_request():
	pass

func leave():
	pass
