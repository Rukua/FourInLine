extends Node2D

var game_state = []

var height = 6
var height_size = 0
var lenght = 7
var lenght_size = 0
var grid_offset = 0
var chip_slot_separation = 64

var pointed_column = 3

var last_player = 0
var current_player = 0
@export var chip_scene: PackedScene

signal game_over
signal continue_next_turn
	
func _physics_process(delta):
	# update arrow position, state and color
	$Arrow.position.x = grid_offset + chip_slot_separation * pointed_column
	
func move_arrow(movement):
	pointed_column = (pointed_column + movement + lenght) % lenght

func is_available_pointed_column():
	return game_state[pointed_column].size() != height

func reset_grid(game_current_player):
	current_player = game_current_player
	$Arrow.show()
	if (current_player == 0):
		$Arrow.texture = load("res://assets/Arraw.png")
	if (current_player == 1):	
		$Arrow.texture = load("res://assets/Arraw_red.png")
		
	game_state.resize(0)
	for i in lenght:
		game_state.append([])
	
	for chip in $Chips.get_children():
		chip.queue_free()
		
	grid_offset = $Grid.position.x
		
func drop_chip(player):
	last_player = player
	current_player = (player + 1) % 2
	if (current_player == 0):
		$Arrow.texture = load("res://assets/Arraw.png")
	if (current_player == 1):	
		$Arrow.texture = load("res://assets/Arraw_red.png")
	
	if (player == 1):
		$Arrow.texture = load("res://assets/Arraw.png")
	if (player == 0):	
		$Arrow.texture = load("res://assets/Arraw_red.png")
	
	if not is_available_pointed_column():
		return false
	else:
		$Arrow.hide()
		# Calculate chip expected position
		var chip_slots = $Grid.get_children()
		var expected_chip_slot = chip_slots[pointed_column + 7 * (height - game_state[pointed_column].size() - 1)]
		var expected_position = expected_chip_slot.position.y + $Grid.position.y
		
		game_state[pointed_column].append(player)
		verify_state(pointed_column, game_state[pointed_column].size() - 1)
		# spawn chip sprite
		var chip = chip_scene.instantiate()
		chip.position.x = grid_offset + pointed_column * 64

		# Spawn the mob by adding it to the Main scene.
		$Chips.add_child(chip)
		
		# animate chip fall (signal verify state and next player turn when chip fall)
		chip.drop_chip(expected_position, player)
		chip.connect("chip_landed", on_chip_landed)
		
		return true
		
func verify_state(column, row):
	var winner = -1
	# verify winning condition
	if search_four_in_line(column, row):
		winner = last_player
	
	if winner != -1:
		emit_signal("game_over", winner)
	
	# verify draw condition
	var is_draw = true
	for col in game_state:
		if col.size() < height:
			is_draw = false
			break
		
	if is_draw:
		emit_signal("game_over", winner)
		
func on_chip_landed():
	$Arrow.show()
	emit_signal("continue_next_turn")

func search_four_in_line(column, row):
	var step = [
		[1, 0],
		[0, 1],
		[1, 1],
		[1, -1],
	]
	
	var has_four_in_line = false
	
	for i in range(4):
		var dir1 = count_in_one_direction(column, row, step[i][0], step[i][1])
		var dir2 = count_in_one_direction(column, row, -step[i][0], -step[i][1])
		
		has_four_in_line = has_four_in_line || (dir1 + dir2 + 1) >= 4
		
	return has_four_in_line
		
			
func count_in_one_direction(column, row, x_dir, y_dir):
	var x = column
	var y = row
	var counter = 0
	
	while 1:
		x += x_dir
		y += y_dir
		# verify if outside of bounds
		if x < 0 || lenght - 1 < x:
			break
			
		if y < 0 || game_state[x].size() <= y:
			break
	
		if game_state[column][row] != game_state[x][y]:
			break
		else:
			counter += 1
			
	return counter
