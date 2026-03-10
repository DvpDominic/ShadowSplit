extends Node

func _start_game():
	GameManager._play_next_level(true)


func _on_button_button_down() -> void:
	_start_game()
