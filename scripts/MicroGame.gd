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

enum GameType {
	TWO_DIMENSIONAL = 0,
	THREE_DIMENSIONAL,
}

@export var microgame_length := MicroGameType.SHORT
@export var command: String = "Play!"
@export var play_type := PlayType.KEYBOARD
@export var game_type := GameType.TWO_DIMENSIONAL

var started: bool
var won_microgame: bool

signal win()
signal lose()
	
func start_game():
	print("sometihng")
	started = true
	won_microgame = false
	$GameTimer.wait_time = microgame_length
	$GameTimer.timeout.connect(game_lose)
	$GameTimer.start()

func game_win():
	win.emit(self, "win")
	
func game_lose():
	if won_microgame:
		print("win")
		return
	print("lose")
	lose.emit(self, "lose")
