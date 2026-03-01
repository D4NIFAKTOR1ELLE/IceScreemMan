extends Control

signal puzzle_solved

@onready var grid = $GridContainer

var empty_tile: TextureButton
var is_shuffling = false

func _ready():
	empty_tile = grid.get_node("Tile8")

	for tile in grid.get_children():
		if tile is TextureButton:
			tile.pressed.connect(_on_tile_pressed.bind(tile))
	
	await get_tree().create_timer(0.5).timeout
	shuffle_puzzle()

func _on_tile_pressed(clicked_tile: TextureButton):
	if is_shuffling: return
	
	var clicked_idx = clicked_tile.get_index()
	var empty_idx = empty_tile.get_index()
	
	if is_adjacent(clicked_idx, empty_idx):
		swap_tiles(clicked_idx, empty_idx)
		if check_win():
			win()

func is_adjacent(idx1: int, idx2: int) -> bool:
	var row1 = idx1 / 3
	var col1 = idx1 % 3
	var row2 = idx2 / 3
	var col2 = idx2 % 3
	return (abs(row1 - row2) + abs(col1 - col2)) == 1

func swap_tiles(idx1: int, idx2: int):
	var tile1 = grid.get_child(idx1)
	var tile2 = grid.get_child(idx2)
	
	grid.move_child(tile1, idx2)
	grid.move_child(tile2, idx1)

func shuffle_puzzle():
	is_shuffling = true
	var moves = 0
	var last_idx = -1
	while moves < 50:
		var empty_idx = empty_tile.get_index()
		var neighbors = []
		
		for i in range(9):
			if is_adjacent(i, empty_idx) and i != last_idx:
				neighbors.append(i)
		
		if neighbors.size() > 0:
			var random_neighbor_idx = neighbors[randi() % neighbors.size()]
			last_idx = empty_idx
			swap_tiles(random_neighbor_idx, empty_idx)
			moves += 1
			await get_tree().create_timer(0.02).timeout
			
	is_shuffling = false

func check_win() -> bool:
	for i in range(grid.get_child_count()):
		if grid.get_child(i).name != "Tile" + str(i):
			return false
	return true

func win():
	puzzle_solved.emit()
	print("win")
