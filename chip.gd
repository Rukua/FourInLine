extends Sprite2D

signal chip_landed

var chip_falling = false
var height_to_fall = 0
var fall_speed = 400


func _physics_process(delta):
	if chip_falling:
		position.y += fall_speed * delta
		if position.y > height_to_fall:
			position.y = height_to_fall
			chip_falling = false
			emit_signal("chip_landed")

func drop_chip(height, player):
	height_to_fall = height
	chip_falling = true
	
	if (player == 0):
		texture = load("res://assets/Chip.png")
	if (player == 1):	
		texture = load("res://assets/Chip_red.png")
	
	show()
