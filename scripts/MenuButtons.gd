extends Control

func _on_play_pressed() -> void:
	Transition.change_scene("res://scenes/microgames/microgame_handler.tscn")

func _on_options_pressed() -> void:
	print_rich("[rainbow]options pressed[/rainbow]")

func _on_exit_pressed() -> void:
	get_tree().quit()
