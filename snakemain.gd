extends Node

@export var snake_scene : PackedScene

#game variables
var score : int
var game_started : bool = false
var won: bool = false
var lose: bool = false

var cell_size : int = 100
var game_offset : Vector2 = Vector2(50, 100)
var cells : int = 8 

#food variables
var food_pos : Vector2
var regen_food : bool = true

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variables
var start_pos = Vector2(4, 4)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move: bool

#when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	$CanvasOverMenu.hide()
	score = 10
	$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
	move_direction = up
	can_move = true
	generate_snake()
	move_food()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start_pos, create tail segments vertically down
	for i in range(1):
		add_segment(start_pos, move_direction)
		
func add_segment(pos: Vector2, direction: Vector2 = Vector2(0, -1)):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + game_offset + Vector2(cell_size / 2, cell_size / 2)
	SnakeSegment.scale = Vector2(2.0, 3.0) 
	add_child(SnakeSegment)
	
		# Rotate the duck segment based on direction
	var angle = 0.0
	if direction == up:
		angle = -PI / 2
	elif direction == down:
		angle = PI / 2
	elif direction == left:
		angle = PI
	elif direction == right:
		angle = 0

	SnakeSegment.rotation = angle

	snake.append(SnakeSegment)


func _process(delta):
	move_snake()
	
func move_snake():
	if can_move:
		#update movement from keypresses
		if Input.is_action_just_pressed("move_down") and move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_up") and move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_left") and move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_right") and move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$MoveTimer.start()

func _on_move_timer_timeout():
	#allow snake movement
	can_move = true
	#use the snake's previous position to move the segments
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		#move all the segments along by one
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = snake_data[i] * cell_size + game_offset + Vector2(cell_size / 2, cell_size / 2)


	rotate_head_to_direction()
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()

func rotate_head_to_direction():
	if snake.size() == 0:
		return

	var head = snake[0]  # First duck segment
	var angle = 0.0

	if move_direction == up:
		angle = -PI / 2  # -90 degrees
	elif move_direction == down:
		angle = PI / 2   # 90 degrees
	elif move_direction == left:
		angle = PI       # 180 degrees
	elif move_direction == right:
		angle = 0        # 0 degrees

	head.rotation = angle

func check_out_of_bounds():
	print("Checking position:", snake_data[0])
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells - 1:
		print("Out of bounds!")
		end_game()

		
func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		score -= 1
		$Hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
		add_segment(old_data[-1], snake_data[-1] - old_data[-1])
		move_food()
		#add sound effect
		$EatSound.play()

		if score <= 0:
			won = true #when the player won
			end_game()


func move_food():
	while true:
		var x = randi_range(0, cells - 1)
		var y = randi_range(0, cells - 1)
		var new_pos = Vector2(x, y)

		# Avoid placing food where the snake already is
		var is_on_snake = false
		for segment_pos in snake_data:
			if segment_pos == new_pos:
				is_on_snake = true
				break
		
		if not is_on_snake:
			food_pos = new_pos
			break
	
	# Snap food to grid using same logic as snake
	$Food.position = food_pos * cell_size + game_offset + Vector2(cell_size / 2, cell_size / 2)
	
	# Scale it to fit better inside the tile
	$Food.scale = Vector2(2, 2)
	
func end_game():
	if won:
		$WinMenu.show()
		$WinSound.play()
		
	else:
		$CanvasOverMenu.show()
		$LoseSound.play()
		
	$MoveTimer.stop()
	game_started = false
	get_tree().paused = true

func _on_canvas_over_menu_restart() -> void:
	new_game()
	
	
