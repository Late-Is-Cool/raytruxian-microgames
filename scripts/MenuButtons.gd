extends Control

func _on_play_pressed():
	Transition.change_scene("res://scenes/save_scene.tscn")

func _on_options_pressed():
	print_rich("[rainbow]options pressed[/rainbow]")

func _on_exit_pressed():
	get_tree().quit()
