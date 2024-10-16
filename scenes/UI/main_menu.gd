extends Control


signal new_game
signal exit_game


func _on_new_game_pressed():
	new_game.emit()


func _on_exit_pressed():
	exit_game.emit()
