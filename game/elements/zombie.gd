extends Control

@onready var request: Array = []

@onready var body: Node = $Body
@onready var dissatisfaction_timer: Timer = $DissatisfactionTimer
@onready var request_scoop: TextureRect = $RequestBubble/Requests/RequestScoop
@onready var requests: GridContainer = $RequestBubble/Requests
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animationplayer: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

signal left

var zombies: Array[String] = [
	"res://assets/art/zombies/zombieBoy.png",
	"res://assets/art/zombies/zombieGirl.png",
	"res://assets/art/zombies/zombieTeen1.png",
	"res://assets/art/zombies/mandela1.png",
	"res://assets/art/zombies/mandela2.png",
	"res://assets/art/zombies/mandela3.png",
	"res://assets/art/zombies/brainZombie.png",
	"res://assets/art/zombies/ladyZombie.png",
	"res://assets/art/zombies/zombie1.png"]

func _ready() -> void:
	audio.stream = load("res://assets/se/Zombie%d.mp3" % randi_range(1, 4))
	
	body.texture = load(zombies[randi_range(0, zombies.size() - 1)])
	
	animationplayer.play("spawn")
	
	spawn()

func spawn():
	audio.play()
	
	for scoop in randi_range(1, 6):
		var random_request: String = Constants.current_flavour_roster.pick_random()
		var new_request_scoop = request_scoop.duplicate()

		request.append(random_request)
		new_request_scoop.self_modulate = Constants.flavours.get(random_request)
		requests.add_child(new_request_scoop)
		new_request_scoop.visible = true
	
	update_progress()
	dissatisfaction_timer.start()

func leave_angrily():
	audio.stream = load("res://assets/se/Zombiemumble.mp3")
	audio.play()
	Constants.sanity = Constants.sanity - 1
	Game.truck_inside.sanity_bar.value -= 1
	
	if Constants.sanity == 0:
		Game.lose()

	audio.stream = load("res://assets/se/universfield-error-02-126514.mp3")
	audio.play()

	animationplayer.play("leave_angry")
	await animationplayer.animation_finished
	left.emit()
	queue_free()

func leave_happily():
	audio.stream = load("res://assets/se/HappyZombie%d.mp3" % randi_range(1, 2))
	audio.play()
	dissatisfaction_timer.stop()
	Constants.cone_in_hand = false
	Game.truck_inside.new_cone.queue_free()
	
	animationplayer.play("leave_happy")
	await animationplayer.animation_finished
	left.emit()
	queue_free()

func update_progress():
	progress_bar.show()
	progress_bar.max_value = dissatisfaction_timer.wait_time
	progress_bar.value = 0
	var tween = progress_bar.create_tween()
	tween.tween_property(progress_bar, "value", progress_bar.max_value, dissatisfaction_timer.wait_time)

func _on_dissatisfaction_timer_timeout() -> void:
	leave_angrily()

func _on_body_mouse_entered() -> void:
	if Constants.cone_in_hand and !Game.truck_inside.new_cone.flavours_in_scoop.is_empty():
		if request.size() != Game.truck_inside.new_cone.flavours_in_scoop.size(): return
		
		for item in Game.truck_inside.new_cone.flavours_in_scoop:
			if !request.has(item): return
			if Game.truck_inside.new_cone.flavours_in_scoop.count(item) != request.count(item): return

		leave_happily()
