extends CharacterBody2D

@export var gravity: float = 2000.0
@export var jump_force: float = 600.0  # Positief! We maken het straks negatief
@export var dive_force: float = 3000.0  # Sterkere zwaartekracht bij duiken
var start = false

func _physics_process(delta):
	if start == false:
		$AnimationPlayer.play("DUCK")
		return
	# Zwaartekracht toepassen
	var _applied_gravity = gravity

	# Als speler naar beneden duikt, verhoog de zwaartekracht
	if Input.is_action_pressed("ui_down"):
		_applied_gravity = dive_force
		
	velocity.y += gravity * delta

	# Springen bij pijl omhoog, alleen als je op de grond staat
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force  # Negatief om omhoog te gaan
		
	if is_on_floor() and !Input.is_action_pressed("down"):
		$AnimationPlayer.play("RUNNING")
	if is_on_floor() and Input.is_action_pressed("down"):
		$AnimationPlayer.play("down")
	if !is_on_floor():
		$AnimationPlayer.play("DUCK")
 
	# Beweging uitvoeren
	move_and_slide()
