extends CharacterBody2D
const speed = 400
var current_dir = "none"

func _ready() -> void:
	$AnimatedSprite2D.play("a_walking")


func _physics_process(delta):
	
	var ardVal = 0
	var csharp_node = get_node("..")
	#velocity.x = int(csharp_node.serialMessage);
	ardVal = int(csharp_node.serialMessage);
	
	if(ardVal == 5): #right
		velocity.x = speed
		velocity.y = 0
	elif(ardVal == 6): #left
		velocity.x = -speed
		velocity.y = 0
	elif(ardVal == 7): #up
		velocity.x = 0
		velocity.y = -speed
	elif(ardVal == 8): #down
		velocity.x = 0
		velocity.y = speed
	else:
		#player_animation(0)
		velocity.x = 0
		velocity.y = 0
		
	print(csharp_node.serialMessage);
	
	move_and_slide()


func player_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("a_walking")
		elif movement == 0:
			animation.play("a_walking")
			
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("a_walking")
		elif movement == 0:
			animation.play("a_walking")
			
	if dir == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("a_walking")
		elif movement == 0:
			animation.play("a_walking")
			
	if dir == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("a_walking")
		elif movement == 0:
			animation.play("a_walking")
