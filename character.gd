extends CharacterBody2D
const speed = 400

func _physics_process(delta):
	var ardVal = 0
	var csharp_node = get_node("..")
	#velocity.x = int(csharp_node.serialMessage);
	ardVal = int(csharp_node.serialMessage);
	
	if(ardVal == 5): #right
		velocity.x = speed
		velocity.y = 0
	elif(ardVal == 7): #left
		velocity.x = -speed
		velocity.y = 0
	elif(ardVal == 8): #up
		velocity.x = 0
		velocity.y = -speed
	elif(ardVal == 9): #down
		velocity.x = 0
		velocity.y = speed
	else:
		#player_animation(0)
		velocity.x = 0
		velocity.y = 0
		
	#print(csharp_node.serialMessage);
	
	move_and_slide()
