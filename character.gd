extends CharacterBody2D

func _physics_process(delta):
	var csharp_node = get_node("..")
	velocity.x = int(csharp_node.serialMessage);

	#print(csharp_node.serialMessage);
	move_and_slide()
