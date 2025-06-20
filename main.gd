extends Node2D

var start = false
var game_won = false
var ardV = 0
var Bloemen_scene = preload("res://bloemen.tscn")

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var TimerLabel = $TimerLabel
@onready var Timer2 = $Timer2

var last_obstacle_time: float = 0
var min_obstacle_gap: float = 0.7
var remaining_time: float = 2

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	ardV = int(arduinoValue)

func _process(delta: float) -> void:
	if !start:
		start = true
		$Duck.start = true
		$ParallaxBackground.playing = true
		$Timer.start()

	if Timer2.time_left > 0.0:
		remaining_time = Timer2.time_left
		TimerLabel.text = "Time: " + str(remaining_time).pad_decimals(1)

	# Wait for Arduino input to switch scene after winning
	if game_won and ardV == 4:
		get_tree().change_scene_to_file("res://maze.tscn")
		print("Switching to maze scene")

func _on_timer_timeout() -> void:
	spawn_Bloemen()
	$Timer.wait_time = randf_range(1.0, 2.0)
	$Timer.start()

func spawn_Bloemen():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_obstacle_time < min_obstacle_gap:
		return

	var Bloemen = Bloemen_scene.instantiate()
	Bloemen.position = Vector2(1177, 289)
	Bloemen.start = true
	Bloemen.body_entered.connect(game_over)
	Bloemen.speed = parallax_background.floor_speed
	add_child(Bloemen)

	last_obstacle_time = current_time

func game_over(_body):
	$Timer.stop()
	$Timer2.stop()
	$ParallaxBackground.playing = false
	$Duck.start = false

	var Bloemen = get_tree().get_nodes_in_group('Bloem')
	for Bloem in Bloemen:
		Bloem.start = false
		Bloem.speed = 0

	get_tree().reload_current_scene()

func _game_win() -> void:
	$Duck.start = false
	$Timer.stop()
	$Timer2.stop()
	$ParallaxBackground.playing = false

	var Bloemen = get_tree().get_nodes_in_group('Bloem')
	for Bloem in Bloemen:
		Bloem.start = false
		Bloem.speed = 0

	$WinLabel.show()
	game_won = true

func _on_timer_2_timeout() -> void:
	_game_win()
