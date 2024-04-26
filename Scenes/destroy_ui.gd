extends Control



func _on_button_pressed():
	$"../../GridMap".request_destroy_start()
