extends Node

var ardV = 0

func _process(delta):
	var csharp_node = get_parent()
	if csharp_node and csharp_node.has_method("get_serial_message"):
		var msg = csharp_node.get_serial_message()
		if msg.is_valid_int():
			ardV = int(msg)
			print("Arduino value:", ardV)
