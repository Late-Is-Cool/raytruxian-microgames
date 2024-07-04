extends Node

@export var microgames: Array[PackedScene]

var current_microgame: MicroGame
var lifes: int
var microgame_speed_float: float = 0.0
var score: int = 4

func _ready() -> void:
	print("yeah")
	lifes = 4
	$MainScreen.visible = true
	$MainAudio.play()
	await $MainAudio.finished
	$MainScreen/Score.visible = true
	new_microgame()

func _process(_delta):
	timer_ongoing()

func new_microgame():
	# setup microgame
	$MainScreen/CommandLabel.text = ""
	var next_game: PackedScene
	next_game = microgames.pick_random()
	current_microgame = next_game.instantiate()
	add_child(current_microgame)
	current_microgame.lose.connect(game_condition)
	current_microgame.win.connect(game_condition)

	# add timer to the microgame
	var game_timer: Timer = Timer.new()
	game_timer.name = "GameTimer"
	game_timer.one_shot = true
	game_timer.wait_time = current_microgame.microgame_length - (current_microgame.microgame_length * microgame_speed_float)
	game_timer.timeout.connect(current_microgame.game_lose)
	current_microgame.add_child(game_timer)
	prints(game_timer.wait_time, microgame_speed_float, current_microgame.microgame_length - microgame_speed_float)

	print(current_microgame)
	$TimerUI/ProgressBar.max_value = current_microgame.microgame_length - (current_microgame.microgame_length * microgame_speed_float)
	$MainAudio.stream = load("res://assets/sfx/go.wav")
	$MainAudio.play()
	$MainScreen/Score.text = str(score)
	$MainScreen/Score/Anim.play("indicate")
	await get_tree().create_timer(1.15 - microgame_speed_float).timeout
	$MainScreen/CommandLabel.text = current_microgame.command
	await $MainAudio.finished
	current_microgame.start_game()
	game_timer.start()
	$MainScreen.visible = false
	$TimerUI.visible = true

func game_condition(scene, condition) -> void:
	# win or lose
	if condition == "win":
		$MainAudio.stream = load("res://assets/sfx/win.wav")
		# if the user won early, just wait until the timer runs out
		await scene.get_node("GameTimer").timeout
		$MainScreen/CommandLabel.text = "Yay! :)"
	elif condition == "lose":
		$MainAudio.stream = load("res://assets/sfx/lose.wav")
		$MainScreen/CommandLabel.text = "Aww :("
		$MainScreen/MarginContainer/CenterContainer/HBoxContainer.get_node("Life"+ str(lifes)).self_modulate.a = 0
		lifes -= 1
	scene.queue_free()
	$MainScreen.visible = true
	$TimerUI.visible = false
	$MainAudio.play()
	await $MainAudio.finished
	if lifes <= 0:
		game_over()
		return
	if score % 4 == 0 and not microgame_speed_float >= 1.0:
		print("speed up")
		$MainAudio.stream = load("res://assets/sfx/speedup.wav")
		$MainAudio.play()
		$MainScreen/CommandLabel.text = "Speed up!"
		await $MainAudio.finished
		microgame_speed_float += 0.08
	score += 1
	$MainAudio.pitch_scale = microgame_speed_float + 1.0
	new_microgame()

func game_over() -> void:
	$MainAudio.stream = load("res://assets/sfx/gameover.mp3")
	$MainAudio.play()
	$MainAudio.pitch_scale = 1.0
	$MainScreen/CommandLabel.text = "Game Over!"
	await $MainAudio.finished
	Transition.change_scene("res://scenes/title_scene.tscn")

func timer_ongoing() -> void:
	if current_microgame != null and current_microgame.started:
		$TimerUI/ProgressBar.value = current_microgame.get_node("GameTimer").time_left
