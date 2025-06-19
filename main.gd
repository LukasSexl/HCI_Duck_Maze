extends Node2D

var start = false
var Bloemen_scene = preload("res://bloemen.tscn")

@onready var parallax_background: ParallaxBackground = $ParallaxBackground


func _process(_delta):
	if !start:
		#print("my name is lukas")
		"""print(Global.ardV)
		if Global.ardV == 3: #Input.is_action_just_pressed("jump"):
			print("hellooo2")

			start = true
			$Duck.start = true
			$ParallaxBackground.playing = true
			$Timer.start()
		"""

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	var ardVal := int(arduinoValue)
	if !start:
		#print("my name is lukas")
		#print(Global.ardV)
		if ardVal == 3: #Input.is_action_just_pressed("jump"):
			print("hellooo2")

			start = true
			$Duck.start = true
			$ParallaxBackground.playing = true
			$Timer.start()
	

func _on_timer_timeout() -> void:
	spawn_Bloemen()
	
func spawn_Bloemen():
	var Bloemen = Bloemen_scene.instantiate()
	Bloemen.position = Vector2(1177, 289)
	Bloemen.start = true
	Bloemen.body_entered.connect(game_over)
	Bloemen.speed = parallax_background.floor_speed
	add_child(Bloemen)

func game_over(body):
	$Restart.show()
	$Timer.stop()
	$ParallaxBackground.playing = false
	$Duck.start = false
	var Bloemen = get_tree().get_nodes_in_group('Bloem')
	for Bloem in Bloemen:
		Bloem.start = false


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event.pressed
	get_tree().reload_current_scene()
