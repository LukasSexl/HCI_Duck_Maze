extends Area2D



var start = false
var speed: float = 1.0

func _ready():
	add_to_group("Bloem")


func _process(delta):
	if start:
		position += Vector2.LEFT * speed * delta
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
