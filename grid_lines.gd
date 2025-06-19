extends Node2D

@export var cell_size: int = 100
@export var cells: int = 9
@export var offset: Vector2 = Vector2(100, 180)  # same as game_offset!


func _draw():
	var grid_width = cells * cell_size
	var grid_height = cells * cell_size

	# Draw vertical lines
	for x in range(cells + 1):
		var x_pos = offset.x + x * cell_size
		draw_line(Vector2(x_pos, offset.y), Vector2(x_pos, offset.y + grid_height), Color(1, 1, 1, 0.2), 2)

	# Draw horizontal lines
	for y in range(cells + 1):
		var y_pos = offset.y + y * cell_size
		draw_line(Vector2(offset.x, y_pos), Vector2(offset.x + grid_width, y_pos), Color(1, 1, 1, 0.2), 2)
