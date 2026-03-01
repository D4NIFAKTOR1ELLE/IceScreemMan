extends Control

signal puzzle_solved

const VALUE_POOL = [7.5, 10.0, 15.0, 30.0]
@export var FUSE_SIZE = Vector2(90, 48)
@export var NUM_SLOTS = 6
@export var GRID_COLS = 2

const FUSE_COLORS = {
	7.5: Color(0.35, 0.60, 1.00),
	10.0: Color(0.25, 0.80, 0.35),
	15.0: Color(1.00, 0.65, 0.10),
	30.0: Color(0.90, 0.25, 0.25),
}

var slots = []
var fuses = []
var slot_values : Array = []
var dragged_fuse = null
var drag_offset = Vector2.ZERO


var fuse_to_slot = {}
var slot_to_fuse = {}

@onready var slot_grid = $SlotGrid
@onready var fuse_holder = $FuseHolder
@onready var win_label = $WinLabel
@onready var fuse_diagram = $FuseDiagram


func _ready():
	win_label.hide()
	slot_grid.columns = GRID_COLS
	_spawn_slots()
	_spawn_fuses()
	fuse_diagram._build_diagram(slot_values)

func _spawn_slots():
	var values = []
	for i in NUM_SLOTS:
		values.append(VALUE_POOL[randi() % VALUE_POOL.size()])

	slot_values = values.duplicate()

	for v in values:
		var slot = TextureButton.new()
		slot.custom_minimum_size = FUSE_SIZE
		slot.set_meta("accepted_value", v)

		var panel = Panel.new()
		panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(panel)

		slot_grid.add_child(slot)
		slots.append(slot)


func _spawn_fuses():
	var values = slots.map(func(s): return s.get_meta("accepted_value"))
	values.shuffle()

	var vp_h = self.get_rect().size.y
	var right_x = self.get_rect().size.x - FUSE_SIZE.x / 2.0 - 20.0
	var spacing = FUSE_SIZE.y + 10.0
	var max_rows = int((vp_h - 40.0) / spacing)

	for i in values.size():
		var col = i / max_rows
		var row = i % max_rows
		var pos = Vector2(right_x - col * (FUSE_SIZE.x + 12.0), 30.0 + row * spacing)
		var fuse = _make_fuse(values[i], pos)

		fuse_holder.add_child(fuse)
		fuses.append(fuse)


func _make_fuse(value, pos):
	var fuse = Area2D.new()
	fuse.set_meta("value", value)

	fuse.position = pos

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = FUSE_SIZE
	cs.shape = rect
	fuse.add_child(cs)

	var img = Image.create(int(FUSE_SIZE.x), int(FUSE_SIZE.y), false, Image.FORMAT_RGBA8)
	img.fill(FUSE_COLORS.get(value, Color.GRAY))
	var sprite = Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(img)
	fuse.add_child(sprite)

	var lbl = Label.new()
	lbl.text = _format_value(value)
	lbl.size = FUSE_SIZE
	lbl.position = -FUSE_SIZE / 2.0
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_color_override("font_color", Color.BLACK)
	fuse.add_child(lbl)

	return fuse


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_try_grab(event.position)
		else:
			_try_drop()
	elif event is InputEventMouseMotion and dragged_fuse != null:
		dragged_fuse.position = event.position + drag_offset


func _try_grab(mouse_pos):
	for i in range(fuses.size() - 1, -1, -1):
		var fuse = fuses[i]
		var fuse_rect = Rect2(fuse.global_position - FUSE_SIZE / 2.0, FUSE_SIZE)
		if fuse_rect.has_point(mouse_pos):
			dragged_fuse = fuse
			drag_offset = fuse.position - mouse_pos

			if fuse_to_slot.has(fuse):
				var prev_slot = fuse_to_slot[fuse]
				slot_to_fuse.erase(prev_slot)
				fuse_to_slot.erase(fuse)

			fuse_holder.move_child(fuse, -1)
			return


func _try_drop():
	if dragged_fuse == null:
		return

	var best_slot = null
	var best_overlap = 0.0
	var fuse_rect = Rect2(dragged_fuse.global_position - FUSE_SIZE / 2.0, FUSE_SIZE)

	for slot in slots:
		if slot_to_fuse.has(slot):
			continue
		var slot_rect = Rect2(slot.global_position, FUSE_SIZE)
		var intersection = fuse_rect.intersection(slot_rect)
		var area = intersection.size.x * intersection.size.y
		if area > best_overlap:
			best_overlap = area
			best_slot = slot

	if best_slot != null and best_overlap > 0.0:
		dragged_fuse.global_position = best_slot.global_position + FUSE_SIZE / 2.0
		slot_to_fuse[best_slot] = dragged_fuse
		fuse_to_slot[dragged_fuse] = best_slot
		_check_win()

	dragged_fuse = null


func _check_win():
	for slot in slots:
		if not slot_to_fuse.has(slot):
			return
		var fuse = slot_to_fuse[slot]
		if fuse.get_meta("value") != slot.get_meta("accepted_value"):
			return
	win_label.show()
	puzzle_solved.emit()


func _format_value(v):
	if v == int(v):
		return str(int(v)) + "A"
	return str(v) + "A"

func _on_button_pressed() -> void:
	if fuse_diagram.visible:
		fuse_diagram.hide()
	else:
		fuse_diagram.show()
