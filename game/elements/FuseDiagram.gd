extends Node2D


@export var GRID_COLS : int = 3
@export var CELL_SIZE : Vector2 = Vector2(90, 48)
@export var PADDING : float = 12.0

const FUSE_COLORS : Dictionary = {
	7.5:  Color(0.35, 0.60, 1.00),
	10.0: Color(0.25, 0.80, 0.35),
	15.0: Color(1.00, 0.65, 0.10),
	30.0: Color(0.90, 0.25, 0.25),
}


func _ready() -> void:
	_build_diagram()


func _build_diagram() -> void:
	var values : Array = FuseData.slot_values

	if values.is_empty():
		var lbl := Label.new()
		lbl.text = "No fuse data yet."
		lbl.position = Vector2(20, 20)
		add_child(lbl)
		return

	var title := Label.new()
	title.text = "Fuse Box Diagram"
	title.position = Vector2(20, 16)
	title.add_theme_font_size_override("font_size", 20)
	add_child(title)

	var step_x : float = CELL_SIZE.x + PADDING
	var step_y : float = CELL_SIZE.y + PADDING
	var origin := Vector2(20.0, 56.0)

	for i in values.size():
		var col : int = i % GRID_COLS
		var row : int = i / GRID_COLS
		var pos := origin + Vector2(col * step_x, row * step_y)
		var value : float = values[i]

		var rect := ColorRect.new()
		rect.color = FUSE_COLORS.get(value, Color(0.5, 0.5, 0.5))
		rect.size = CELL_SIZE
		rect.position = pos
		add_child(rect)

		var val_lbl := Label.new()
		val_lbl.text = _format_value(value)
		val_lbl.size = CELL_SIZE
		val_lbl.position = pos
		val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		val_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		val_lbl.add_theme_font_size_override("font_size", 16)
		val_lbl.add_theme_color_override("font_color", Color.BLACK)
		add_child(val_lbl)


func _format_value(v: float) -> String:
	if v == int(v):
		return str(int(v)) + "A"
	return str(v) + "A"
