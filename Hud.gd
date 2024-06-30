extends CanvasLayer


signal start_game_signal


func _on_start_game_pressed():
	start_game()

func _on_restart_game_pressed():
	start_game()

func start_game():
	$ScoreP1.hide()
	$ScoreP2.hide()
	$GameName.hide()
	$StartGame.hide()
	$RestartGame.hide()
	
	emit_signal("start_game_signal")

func update_score(player1, player2):
	$ScoreP1.text = "Wins P1: " + str(player1)
	$ScoreP2.text = "Wins P2: " + str(player2)
	
func game_over():
	$ScoreP1.show()
	$ScoreP2.show()
	$GameName.show()
	$RestartGame.show()
