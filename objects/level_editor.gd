extends Node2D

# Set this constant before game start
const in_edit_mode: bool = false
var current_level_name = "RHYTHM_HELL"
#@onready var Signals = preload("res://objects/signals.gd")


# Time it takes for falling key to reach critical spot
var fk_fall_time: float = 2.2
var fk_output_arr = [[], [], [], []]

var level_info = {
	"RHYTHM_HELL" = {
		"fk_times": "[[2.5, 6.5, 10.5, 16.0, 19.7, 27.2, 30.8, 36.3, 40.4], 
		[3.0, 5.2, 7.0, 11.5, 15.5, 20.0, 24.3, 28.1, 34.8, 36.2], 
		[2.2, 3.5, 7.5, 10.7, 14.5, 19.0, 23.5, 31.5, 32.2], 
		[1.2, 4.0, 6.1, 8.0, 12.0, 17.2, 26.5, 27.4, 38.4]]",
		"music": load("res://music/Rhythm Hell.wav")
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		Signals.KeyListenerPress.connect(KeyListenerPress)
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "1"
				1:
					button_name = "2"
				2:
					button_name = "3"
				3:
					button_name = "4"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
			
			counter += 1

func KeyListenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num].append($MusicPlayer.get_playback_position() - fk_fall_time)

func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)


func _on_music_player_finished():
	print(fk_output_arr)
