extends MicroGame

func _process(_delta) -> void:
        $Bowl.position.x = get_viewport().get_mouse_position().x

func start_game() -> void:
        super()
        game_win()
        await get_tree().create_timer(3).timeout
