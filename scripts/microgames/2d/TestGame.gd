extends MicroGame

func _input(event) -> void:
        # if started and the key is not held down
        if event is InputEventKey and !event.is_pressed() and $UI/Control/ProgressBar.value < $UI/Control/ProgressBar.max_value and started:
                $UI/Control/ProgressBar.value += 1
        if $UI/Control/ProgressBar.value == $UI/Control/ProgressBar.max_value and !won_microgame:
                game_win()
