extends Node2D
class_name Minigame

signal minigame_finished
signal minigame_failed

var start = false
var game_won = false
var ardV = 0
var Bloemen_scene = preload("res://bloemen.tscn")
@export var FLOWER: PackedScene

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var TimerLabel = $TimerLabel
@onready var duration: Timer = $Duration

@onready var camera_2d: Camera2D = $Camera2D
@onready var arduino_script: Node = $ArduinoScript


var last_obstacle_time: float = 0
var min_obstacle_gap: float = 0.7
var remaining_time: float = 15

func _ready() -> void:
	get_tree().get_first_node_in_group("arduino").ClosePort()
	arduino_script.SetUpPort()

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	ardV = int(arduinoValue)

func _process(delta: float) -> void:
	if !start:
		start = true
		$Duck.start = true
		$ParallaxBackground.playing = true
		$Timer.start()

	if duration.time_left > 0.0:
		remaining_time = duration.time_left
		TimerLabel.text = "Time: " + str(remaining_time).pad_decimals(1)
	
func _on_timer_timeout() -> void:
	spawn_Bloemen()
	$Timer.wait_time = randf_range(1.0, 2.0)
	$Timer.start()

func spawn_Bloemen():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_obstacle_time < min_obstacle_gap:
		return

	var Bloemen: Bloem = FLOWER.instantiate()
	Bloemen.position = Vector2(1177, 289)
	Bloemen.start = true
	Bloemen.body_entered.connect(game_over)
	Bloemen.speed = parallax_background.floor_speed
	add_child(Bloemen)

	last_obstacle_time = current_time

func game_over(_body):
	$Timer.stop()
	duration.stop()
	$ParallaxBackground.playing = false
	$Duck.start = false

	var Bloemen = get_tree().get_nodes_in_group('Bloem')
	for Bloem in Bloemen:
		Bloem.start = false
		Bloem.speed = 0
		
	arduino_script.ClosePort()
	get_tree().get_first_node_in_group("arduino").SetUpPort()
	
	minigame_failed.emit()
	call_deferred("queue_free")

func _game_win() -> void:
	$Duck.start = false
	$Timer.stop()
	duration.stop()
	$ParallaxBackground.playing = false

	var Bloemen = get_tree().get_nodes_in_group('Bloem')
	for Bloem in Bloemen:
		Bloem.start = false
		Bloem.speed = 0

	$WinLabel.show()
	game_won = true
	_on_complete()
	
func _on_complete():
	for node in get_tree().get_nodes_in_group("Lilly"):
		node.visible = true
	
	get_tree().get_first_node_in_group("character").visible = true
	get_tree().get_first_node_in_group("tilemap").visible = true
	
	get_tree().paused = false
	get_tree().get_first_node_in_group("mainCamera").enabled = true
	
	arduino_script.ClosePort()
	get_tree().get_first_node_in_group("arduino").SetUpPort()
	call.call_deferred("queue_free")
	#emit_signal("minigame_finished")
	#queue_free()  # Remove minigame scene


func _on_timer_2_timeout() -> void:
	_game_win()
