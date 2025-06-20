extends CharacterBody2D 

const STEP_DISTANCE := 100

var walk := false
var last_step_val := -1
var move_direction := Vector2.RIGHT  # Default direction
var direction_string := "right"
var last_direction_string := "right"  # Track previous direction for animation update
var lily_collisions = 0
@onready var camera_2d: Camera2D = $Camera2D

@export var minigame1: PackedScene
@export var minigame2: PackedScene
@export var minigame3: PackedScene

@onready var ducky_1: Sprite2D = %ducky1
@onready var ducky_2: Sprite2D = %ducky2
@onready var ducky_3: Sprite2D = %ducky3
@onready var scoreboard_underlay: Sprite2D = %scoreboard_underlay

func _ready():
	$AnimatedSprite2D.play("right_left_foot")
	get_tree().get_first_node_in_group("arduino").SetUpPort()
	
func _physics_process(delta):
	var ardVal = 3
	

func on_lily_collision():
	lily_collisions += 1
	if(lily_collisions == 1):
		ducky_1.show()
	elif(lily_collisions == 2):
		ducky_2.show()
	else:
		ducky_3.show()
	print("Hit lily count: ", lily_collisions)
	start_minigame(lily_collisions)

func instatiate_minigame_number(gameNumber: int):
	if gameNumber == 1:
		instantiate_minigame(minigame1)
	elif gameNumber == 2:
		instantiate_minigame(minigame1)
	elif gameNumber == 3:
		instantiate_minigame(minigame1)

func instantiate_minigame(game: PackedScene):
	var instance = game.instantiate()
	var parent = get_tree().get_first_node_in_group("minigame_container")
	instance.minigame_failed.connect(restart_minigame)
	parent.add_child(instance)
	
	for node in get_tree().get_nodes_in_group("Lilly"):
		node.visible = false
	
	get_tree().get_first_node_in_group("character").visible = false
	get_tree().get_first_node_in_group("tilemap").visible = false

func restart_minigame():
	instantiate_minigame(minigame1)

func start_minigame(index: int):
	instatiate_minigame_number(index)
	camera_2d.enabled = false
	#disconnect_arduino()

		 #Connect minigame finish signal
		#if minigame.has_signal("minigame_finished"):
			#minigame.connect("minigame_finished", Callable(self, "_on_minigame_finished"))
	#else:
		#print("Invalid minigame index: ", index)

func disconnect_arduino():
	var script = get_tree().get_first_node_in_group("arduino")
	script.disconnect("CustomInputEventHandler", _on_arduino_script_custom_input)
	#get_tree().get_first_node_in_group("arduino").CustomInputEventHandler.disconnect(_on_arduino_script_custom_input)

func connect_arduino():
	var script = get_tree().get_first_node_in_group("arduino")
	script.connect("CustomInputEventHandler", _on_arduino_script_custom_input)

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	var ardVal := int(arduinoValue)

	# Update direction for any value (even when not walking)
	match ardVal:
		1:
			move_direction = Vector2.RIGHT
			direction_string = "right"
		2:
			move_direction = Vector2.LEFT
			direction_string = "left"
		3:
			move_direction = Vector2.UP
			direction_string = "up"
		4:
			move_direction = Vector2.DOWN
			direction_string = "down"

	# Always update animation if direction changed (even if not stepping)
	if direction_string != last_direction_string:
		var foot := "left_foot" if walk else "right_foot"
		$AnimatedSprite2D.play(direction_string + "_" + foot)
		last_direction_string = direction_string

	# Step trigger — only when 0 or 11 is received and not the same as last
	if (ardVal == 11 or ardVal == 0) and ardVal != last_step_val:
		walk = !walk  # Alternate foot
		var foot := "left_foot" if walk else "right_foot"
		$AnimatedSprite2D.play(direction_string + "_" + foot)

		velocity = move_direction * STEP_DISTANCE
		move_and_slide()

	# Prevent repeated stepping from same signal
	if ardVal == 11 or ardVal == 0:
		last_step_val = ardVal
	else:
		last_step_val = -1
