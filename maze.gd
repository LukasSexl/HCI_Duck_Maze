extends Node2D

# TileMap node reference
@onready var tilemap = $TileMapLayer

# Constants
const ROWS = 11
const COLS = 11
const WALL = Vector2i(0, 0)  # Wall tile coordinates in tileset
const PATH = Vector2i(1, 0)  # Path tile coordinates in tileset

# Maze array
var maze = []


func _ready():
	# Initialize maze with walls
	reset_maze()
	# Generate initial maze

	generate_maze()

func reset_maze():
	# Initialize 2D array filled with walls (1)
	maze = []
	for r in range(ROWS):
		var row = []
		for c in range(COLS):
			row.append(1)  # 1 represents walls
		maze.append(row)

func generate_maze():
	# Reset maze to all walls
	reset_maze()
	
	# Start at position (1,1)
	var start_row = 1
	var start_col = 1
	maze[start_row][start_col] = 0  # 0 represents path
	
	# Start carving passages
	carve_passages(start_row, start_col)
	
	# Update the tilemap
	draw_maze()

func carve_passages(r, c):
	# Define directions: [up, right, down, left] - moving 2 cells to carve passages
	var directions = [
		[-2, 0],  # Up
		[0, 2],   # Right
		[2, 0],   # Down
		[0, -2]   # Left
	]
	
	# Shuffle directions randomly
	directions.shuffle()
	
	# Try each direction
	for dir in directions:
		var dr = dir[0]
		var dc = dir[1]
		
		var new_r = r + dr
		var new_c = c + dc
		
		# Check if the new position is valid and still a wall
		if (new_r > 0 and new_r < ROWS - 1 and 
			new_c > 0 and new_c < COLS - 1 and 
			maze[new_r][new_c] == 1):
			
			# Carve path by setting the cell between current and new position to path
			maze[r + dr/2][c + dc/2] = 0
			# Set the new position to path
			maze[new_r][new_c] = 0
			# Continue carving from new position
			carve_passages(new_r, new_c)

func draw_maze():
	# Clear the tilemap
	tilemap.clear()
	var path_positions = []

	# Draw the maze
	for r in range(ROWS):
		for c in range(COLS):
			var tile_type = WALL if maze[r][c] == 1 else PATH
			tilemap.set_cell(Vector2i(c, r), 0, tile_type)
			if maze[r][c] == 0:  # It's a path
				path_positions.append(Vector2i(c, r))

		# Shuffle and pick 3 random positions
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	path_positions.shuffle()

	#var baby_duck_scene = load("res://baby_duck.tscn")
	var lilly_scene = load("res://water_lilly.tscn")
	
	

	for i in range(min(3, path_positions.size())):
		var pos = path_positions[i]
		#var duck = baby_duck_scene.instantiate()
		var lilly = lilly_scene.instantiate()

		#duck.position = Vector2(pos.x * 32 + 16, pos.y * 32 + 16)
		lilly.position = Vector2(pos.x * 32 + 16, pos.y * 32 + 16)
	
		add_child(lilly)
		#add_child(duck)
		
		#print(duck.position)
		
func _on_minigame_finished():
	var container = get_node("MinigameContainer")
	if container.get_child_count() > 0:
		var minigame = container.get_child(0)
		minigame.queue_free()

	set_process(true)
	set_physics_process(true)
	get_tree().paused = false


#func _on_button_pressed() -> void:
	#generate_maze()
