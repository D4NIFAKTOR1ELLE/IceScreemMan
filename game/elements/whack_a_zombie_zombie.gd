extends Area2D


@onready var anim = $AnimationPlayer
@onready var zombie = $ZombieHoleSprite/ZombieSprite

@export var normal_texture: Texture2D
@export var whacked_texture: Texture2D

var is_vulnerable = false
var is_whacked = false

func spawn_zombie():
	if is_vulnerable or is_whacked: return
	is_whacked = false
	zombie.texture = normal_texture
	anim.play("PopUp")
	is_vulnerable = true
	await get_tree().create_timer(1).timeout
	if is_vulnerable:
		retreat()

func retreat():
	anim.play_backwards("PopUp")
	await get_tree().create_timer(0.5).timeout
	is_vulnerable = false
	is_whacked = false


func handle_hit():
	if is_vulnerable and not is_whacked:
		is_whacked = true
		if whacked_texture:
			zombie.texture = whacked_texture 
		retreat()
		
