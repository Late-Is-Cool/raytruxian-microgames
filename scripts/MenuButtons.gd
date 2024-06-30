extends Control

func _on_play_pressed():
	Transition.change_scene("res://scenes/microgames/microgame_handler.tscn")

func _on_options_pressed():
	print_rich("[rainbow]options pressed[/rainbow]")

func _on_exit_pressed():
	get_tree().quit()
