extends Sprite2D

@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
#@onready var Signals = preload("res://objects/signals.gd")

@export var key_name: String = ""

var falling_key_queue = []

# If distance_from_pass is less than threshold, give that score
var perfect_press_threshold: float = 70
var great_press_threshold: float = 80
var good_press_threshold: float = 90
var ok_press_threshold: float = 100
# otherwise, miss

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20

func _ready():
	$GlowOverlay.frame = frame + 4
	Signals.CreateFallingKey.connect(CreateFallingKey)

var ardV = "0"

func _on_arduino_script_custom_input(arduinoValue: String) -> void:
	ardV = arduinoValue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("my arduino value is (" + ardV + ") and my key_name is (" + key_name + ")")

	if ardV == key_name:
		Signals.KeyListenerPress.emit(key_name, frame)
		print("you pressed my key name!! " + key_name)
	
	# Make sure there is a falling key to check for this given key
	if falling_key_queue.size() > 0:
		
		var front_key = falling_key_queue.front()

		# If the key was already freed somehow, remove it safely
		if !is_instance_valid(front_key):
			falling_key_queue.pop_front()
			return

		# If that falling key has passed, remove it from the queue
		if  front_key.has_passed:
			falling_key_queue.pop_front()
			
			# PRINT MISS
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("MISS")
			st_inst.global_position = global_position + Vector2(0, -20)
			Signals.ResetCombo.emit()
			
		# If key is pressed, pop from the queue and calculate distance from critical point
		if ardV == key_name:
			var key_to_pop = falling_key_queue.pop_front()
			
			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
			
			$AnimationPlayer.stop()
			$AnimationPlayer.play("key_hit")
			
			var press_score_text: String = ""
			if distance_from_pass < perfect_press_threshold:
				Signals.IncrementScore.emit(perfect_press_score)
				press_score_text = "PERFECT"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < great_press_threshold:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "GREAT"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < good_press_threshold:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "GOOD"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < ok_press_threshold:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "OK"
				Signals.IncrementCombo.emit()
			else:
				press_score_text = "MISS"
				Signals.ResetCombo.emit()
			
			key_to_pop.queue_free()
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo(press_score_text)
			st_inst.global_position = global_position + Vector2(0, -20)
	ardV = "0"
	
	

func CreateFallingKey(button_name: String):
	print("i am asked to create a falling key with button name " + button_name)
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.x, frame + 4)
		
		falling_key_queue.push_back(fk_inst)


func _on_random_spawn_timer_timeout():
	#CreateFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
