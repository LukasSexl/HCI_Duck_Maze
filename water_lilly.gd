extends Area2D

@export var minigame_index := 0
var triggered = false  # Prevent double triggering

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	get_tree().root.print_tree()

	#get_node("Maze/node_2d/character/Camera2D/ducky1").visible = true

	
func _on_body_entered(body):
	if body.name == "character" and not triggered:
		triggered = true
		body.on_lily_collision()  # Call duck's method
		queue_free()  # Optional: remove lily after collection
		#var duck_ui_scene = load("res://character.tscn")
		#var duck_ui = duck_ui_scene.instantiate()
		#add_child(duck_ui)
		
