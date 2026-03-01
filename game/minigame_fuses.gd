extends Node2D

signal puzzle_solved

var simultaneous_scene = preload("res://game/FuseDiagram.tscn").instantiate()

@onready var VALUE_POOL : Array = [7.5, 10.0, 15.0, 30.0]
@export var FUSE_SIZE : Vector2 = Vector2(90, 48)
@export var NUM_SLOTS : int = 6
@export var GRID_COLS : int = 3

const FUSE_COLORS : Dictionary = {
	7.5:Color(0.35, 0.60, 1.00),
	10.0:Color(0.25, 0.80, 0.35),
	15.0:Color(1.00, 0.65, 0.10),
	30.0:Color(0.90, 0.25, 0.25),
}

var slots : Array = []
var fuses : Array = []
var dragged_fuse : Area2D = null
var drag_offset : Vector2 = Vector2.ZERO

@onready var slot_grid : GridContainer = $SlotGrid
@onready var fuse_holder : Node2D = $FuseHolder
@onready var win_label : Label = $WinLabel

func _ready() -> void:
	win_label.hide()
	slot_grid.columns = GRID_COLS
	_spawn_slots()
	await get_tree().process_frame
	await get_tree().process_frame
	_spawn_fuses()

func _spawn_slots() -> void:
	var values : Array = []
	for i in NUM_SLOTS:
		values.append(VALUE_POOL[randi() % VALUE_POOL.size()])

	FuseData.slot_values = values.duplicate()

	for v in values:
		var slot := TextureButton.new()
		slot.custom_minimum_size = FUSE_SIZE
		slot.set_meta("accepted_value", v)
		slot.set_meta("occupying_fuse", null)

		var panel := Panel.new()
		panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(panel)

		slot_grid.add_child(slot)
		slots.append(slot)

func _spawn_fuses() -> void:
	var values : Array = slots.map(func(s): return s.get_meta("accepted_value"))
	values.shuffle()

	var vp_h : float = get_viewport_rect().size.y
	var right_x : float = get_viewport_rect().size.x - FUSE_SIZE.x / 2.0 - 20.0
	var spacing : float = FUSE_SIZE.y + 10.0
	var max_rows : int = int((vp_h - 40.0) / spacing)

	for i in values.size():
		var col : int = i / max_rows
		var row : int = i % max_rows
		var pos := Vector2(
			right_x  - col * (FUSE_SIZE.x + 12.0),
			30.0 + row * spacing
		)
		var fuse := _make_fuse(values[i], pos)
		fuse_holder.add_child(fuse)
		fuses.append(fuse)


func _make_fuse(value: float, pos: Vector2) -> Area2D:
	var fuse := Area2D.new()
	fuse.set_meta("value",        value)
	fuse.set_meta("snapped_slot", null)
	fuse.position = pos

	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = FUSE_SIZE
	cs.shape = rect
	fuse.add_child(cs)

	var img := Image.create(int(FUSE_SIZE.x), int(FUSE_SIZE.y), false, Image.FORMAT_RGBA8)
	img.fill(FUSE_COLORS.get(value, Color.GRAY))
	var sprite := Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(img)
	fuse.add_child(sprite)

	var lbl := Label.new()
	lbl.text = _format_value(value)
	lbl.size = FUSE_SIZE
	lbl.position = -FUSE_SIZE / 2.0
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_color_override("font_color", Color.BLACK)
	fuse.add_child(lbl)

	return fuse

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_try_grab(event.position)
		else:
			_try_drop()

	elif event is InputEventMouseMotion and dragged_fuse != null:
		dragged_fuse.position = event.position + drag_offset


func _try_grab(mouse_pos: Vector2) -> void:
	for i in range(fuses.size() - 1, -1, -1):
		var fuse : Area2D = fuses[i]
		var fuse_rect := Rect2(fuse.position - FUSE_SIZE / 2.0, FUSE_SIZE)
		if fuse_rect.has_point(mouse_pos):
			dragged_fuse = fuse
			drag_offset = fuse.position - mouse_pos
			var prev_slot = fuse.get_meta("snapped_slot", null)
			if prev_slot != null:
				prev_slot.set_meta("occupying_fuse", null)
				fuse.set_meta("snapped_slot", null)
			fuse_holder.move_child(fuse, -1)
			return


func _try_drop() -> void:
	if dragged_fuse == null:
		return

	var best_slot : TextureButton = null
	var best_overlap : float = 0.0
	var fuse_rect := Rect2(dragged_fuse.position - FUSE_SIZE / 2.0, FUSE_SIZE)

	for slot in slots:
		if slot.get_meta("occupying_fuse", null) != null:
			continue
		var slot_rect := Rect2(slot.global_position, FUSE_SIZE)
		var intersection := fuse_rect.intersection(slot_rect)
		var area := intersection.size.x * intersection.size.y
		if area > best_overlap:
			best_overlap = area
			best_slot = slot

	if best_slot != null and best_overlap > 0.0:
		dragged_fuse.position = best_slot.global_position + FUSE_SIZE / 2.0
		best_slot.set_meta("occupying_fuse", dragged_fuse)
		dragged_fuse.set_meta("snapped_slot", best_slot)
		_check_win()

	dragged_fuse = null

func _check_win() -> void:
	for slot in slots:
		var fuse = slot.get_meta("occupying_fuse", null)
		if fuse == null:
			return 
		if fuse.get_meta("value", null) != slot.get_meta("accepted_value", null):
			return
	win_label.show()
	puzzle_solved.emit

func _format_value(v: float) -> String:
	if v == int(v):
		return str(int(v)) + "A"
	return str(v) + "A"


func _on_button_pressed() -> void:
	get_tree().root.add_child(simultaneous_scene)
