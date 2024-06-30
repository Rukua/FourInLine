extends Node2D

var game_started = false
var chip_falling = false
var game_ended = false
var hud_hidden = false
var player0 = 0
var player1 = 0
var current_player = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameGrid.reset_grid(randi_range(0, 1))

func _physics_process(delta):
	if hud_hidden:
		return
		
	if (game_started and not chip_falling):
		if game_ended:
			$Hud.game_over()
			$GameGrid/Arrow.hide()
			hud_hidden = true
			
		if Input.is_action_just_pressed("move_right"):
			$GameGrid.move_arrow(1)
		if Input.is_action_just_pressed("move_left"):
			$GameGrid.move_arrow(-1)
			
		if Input.is_action_just_pressed("drop_chip"):
			if $GameGrid.drop_chip(current_player):
				current_player = (current_player + 1) % 2
				chip_falling = true

func _on_game_grid_game_over(winner):
	game_ended = true
	if winner == 0:
		player0 += 1
	elif winner == 1:
		player1 += 1
		
	$Hud.update_score(player0, player1)


func _on_hud_start_game_signal():
	game_started = true
	game_ended = false
	chip_falling = false
	hud_hidden = false
	current_player = randi_range(0, 1)
	$GameGrid.reset_grid(current_player)
	$GameGrid.show()

func _on_game_grid_continue_next_turn():
	chip_falling = false
