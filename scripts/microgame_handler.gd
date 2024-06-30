extends Node

@export var microgames: Array[PackedScene]

var current_microgame: MicroGame
var lifes: int

func _ready():
	print("yeah")
	lifes = 4
	for life in lifes:
		$MainScreen/MarginContainer/CenterContainer/HBoxContainer.get_node("Life"+ str(life + 1)).self_modulate.a = 255
		print("es")
	$MainScreen.visible = true
	$MainAudio.play()
	await $MainAudio.finished
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

	print(current_microgame)
	$TimerUI/ProgressBar.max_value = current_microgame.microgame_length
	$MainAudio.stream = load("res://assets/sfx/go.wav")
	$MainAudio.play()
	await get_tree().create_timer(1.0).timeout
	$MainScreen/CommandLabel.text = current_microgame.command
	await $MainAudio.finished
	current_microgame.start_game()
	$MainScreen.visible = false
	$TimerUI.visible = true

func game_condition(scene, condition):
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
	new_microgame()

func game_over():
	$MainAudio.stream = load("res://assets/sfx/gameover.mp3")
	$MainAudio.play()
	$MainScreen/CommandLabel.text = "Game Over!"
	await $MainAudio.finished
	Transition.change_scene("res://scenes/title_scene.tscn")

func timer_ongoing():
	if current_microgame != null and current_microgame.started:
		$TimerUI/ProgressBar.value = current_microgame.get_node("GameTimer").time_left
