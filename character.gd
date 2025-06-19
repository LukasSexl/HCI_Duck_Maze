extends CharacterBody2D 

const STEP_DISTANCE := 100

var walk := false
var last_step_val := -1
var move_direction := Vector2.RIGHT  # Default direction
var direction_string := "right"
var last_direction_string := "right"  # Track previous direction for animation update
var lily_collisions = 0

func _ready():
	$AnimatedSprite2D.play("right_left_foot")

func _physics_process(delta):
	var ardVal = 3
	# Update animation if direction changed
	

func on_lily_collision():
	lily_collisions += 1
	if(lily_collisions == 1):
		get_node("Camera2D/ducky1").show()
	elif(lily_collisions == 2):
		get_node("Camera2D/ducky2").show()
	else:
		get_node("Camera2D/ducky3").show()
	print("Hit lily count: ", lily_collisions)
	start_minigame(lily_collisions)

func start_minigame(index: int):
	match index:
		1:
			print("Start minigame 1")
			get_tree().change_scene_to_file("res://levels/game_level.tscn")
		2:
			print("Start minigame 2")
			get_tree().change_scene_to_file("res://minigame_2.tscn")
		3:
			print("Start minigame 3")
			get_tree().change_scene_to_file("res://minigame_3.tscn")
		_:
			print("All minigames completed!")


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
