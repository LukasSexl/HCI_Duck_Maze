extends Area2D

@export var minigame_index := 0
var triggered = false  # Prevent double triggering

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func _on_body_entered(body):
	if body.name == "character" and not triggered:
		triggered = true
		body.on_lily_collision()  # Call duck's method
		queue_free()  # Optional: remove lily after collection
