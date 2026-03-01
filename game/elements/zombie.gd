extends Control

@onready var request: Array = []

@onready var body: Node = $Body
@onready var dissatisfaction_timer: Timer = $DissatisfactionTimer
@onready var request_scoop: TextureRect = $RequestBubble/Requests/RequestScoop
@onready var requests: GridContainer = $RequestBubble/Requests
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animationplayer: AnimationPlayer = $AnimationPlayer

signal left

var zombies: Array[String] = [
	"res://assets/art/zombies/zombieBoy.png",
	"res://assets/art/zombies/zombieGirl.png",
	"res://assets/art/zombies/zombieTeen1.png",
	"res://assets/art/zombies/mandela1.png",
	"res://assets/art/zombies/mandela2.png",
	"res://assets/art/zombies/mandela3.png"]

func _ready() -> void:
	body.texture = load(zombies[randi_range(0, zombies.size() - 1)])
	
	animationplayer.play("spawn")
	
	spawn()

func spawn():
	for scoop in randi_range(1, 6):
		var random_request: String = Constants.game_instance.current_flavour_roster.pick_random()
		var new_request_scoop = request_scoop.duplicate()

		request.append(random_request)
		new_request_scoop.self_modulate = Constants.flavours.get(random_request)
		requests.add_child(new_request_scoop)
		new_request_scoop.visible = true
	
	update_progress()
	dissatisfaction_timer.start()

func leave_angrily():
	Constants.sanity = Constants.sanity - 1
	Constants.game_instance.truck_inside.sanity_bar.value -= 1
	
	if Constants.sanity == 0:
		Constants.game_instance.lose()
		
	left.emit()
		
	queue_free()

func leave_happily():
	dissatisfaction_timer.stop()
	Constants.cone_in_hand = false
	Constants.new_cone.queue_free()
	
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
	if Constants.cone_in_hand and !Constants.new_cone.flavours_in_scoop.is_empty():
		for item in Constants.new_cone.flavours_in_scoop:
			if !request.has(item): return
			if Constants.new_cone.flavours_in_scoop.count(item) != request.count(item): return

		leave_happily()
