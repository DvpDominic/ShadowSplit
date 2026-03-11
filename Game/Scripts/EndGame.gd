extends Node

func _start_game():
	GameManager._play_next_level(true)

func _restart_game():
	GameManager.current_level = 0
	GameManager._play_next_level(true)

func _on_start_button() -> void: 
	_start_game()

func _on_restart_button() -> void:
	_restart_game()
