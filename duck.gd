extends CharacterBody2D

@export var gravity: float = 2000.0
@export var jump_force: float = 600.0  # Positief! We maken het straks negatief
@export var dive_force: float = 3000.0  # Sterkere zwaartekracht bij duiken
var start = false

var previous_ardV := -1
var ardVal = 0

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	ardVal = int(arduinoValue)
	print("Input received:", ardVal)


func _physics_process(delta) -> void:
	var ardV = ardVal
	ardVal = -1  # Reset input for next frame

	if start == false:
		$AnimationPlayer.play("DUCK")
		previous_ardV = ardV
		return

	var _applied_gravity = gravity
	if ardV == 4:
		_applied_gravity = dive_force

	# Jump only when ardV == 3 (pressed this frame)
	if ardV == 3 and is_on_floor():
		velocity.y = -jump_force
		print("Jump!")

	velocity.y += _applied_gravity * delta

	# Animations...
	if ardV != 4 and is_on_floor():
		$AnimationPlayer.play("RUNNING")
	elif is_on_floor() and ardV == 4:
		$AnimationPlayer.play("down")
		print("ducking")
	elif !is_on_floor():
		$AnimationPlayer.play("DUCK")

	move_and_slide()

	previous_ardV = ardV
