extends Node
class_name MicroGame

enum MicroGameType {
	SHORT = 5,
	LONG = 10,
}

enum PlayType {
	KEYBOARD = 0,
	MOUSE,
	BOTH,
}

# enum GameType {
# 	TWO_DIMENSIONAL = 0,
# 	THREE_DIMENSIONAL,
# }

@export var microgame_length: MicroGameType = MicroGameType.SHORT
@export var command: String = "Play!"
@export var play_type: PlayType = PlayType.KEYBOARD
# @export var game_type: GameType = GameType.TWO_DIMENSIONAL

@onready var won_microgame: bool = false
@onready var difficulty_level: int = 0

var speed_float: float = 0.0

var started: bool = false

signal win()
signal lose()

func start_game() -> void:
	print("sometihng")
	started = true

func game_win() -> void:
	won_microgame = true
	win.emit(self, "win")
	
func game_lose() -> void:
	if won_microgame:
		print("win")
		return
	print("lose")
	lose.emit(self, "lose")
