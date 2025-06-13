extends CharacterBody2D
const speed = 50
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("standing_down")


func _physics_process(delta):
	
	var ardVal = 0
	var csharp_node = get_node("..")
	#velocity.x = int(csharp_node.serialMessage);
	ardVal = int(csharp_node.serialMessage);
	
	if(ardVal == 5): #right
		velocity.x = speed
		velocity.y = 0
		current_dir = "right"
	elif(ardVal == 6): #left
		velocity.x = -speed
		velocity.y = 0
		current_dir = "left"
	elif(ardVal == 7): #up
		velocity.x = 0
		velocity.y = -speed
		current_dir = "up"
	elif(ardVal == 8): #down
		velocity.x = 0
		velocity.y = speed
		current_dir = "down"
	else:
		#player_animation(0)
		velocity.x = 0
		velocity.y = 0
		
	print(csharp_node.serialMessage);
	
	move_and_slide()
	
	if velocity.length() > 0:
		player_animation(1)
	else:
		player_animation(0)


func player_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D

	if dir == "right":
		#animation.flip_h = false
		if movement == 1:
			animation.play("walking_right")
		elif movement == 0:
			animation.play("standing_right")
			
	if dir == "left":
		#animation.flip_h = true
		if movement == 1:
			animation.play("walking_left")
		elif movement == 0:
			animation.play("standing_left")
			
	if dir == "up":
		#animation.flip_h = true
		if movement == 1:
			animation.play("walking_up")
		elif movement == 0:
			animation.play("standing_up")
			
	if dir == "down":
		#animation.flip_h = true
		if movement == 1:
			animation.play("walking_down")
		elif movement == 0:
			animation.play("standing_down")
