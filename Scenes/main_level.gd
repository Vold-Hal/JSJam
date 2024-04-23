extends Node3D

var day: float = 0
@export var speed: int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var last_registered_day: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	day += speed * speed * delta
	while day - last_registered_day > 1:
		next_day()


func next_day():
	last_registered_day += 1
	$Buildings.next_day()
	$MainUI.update_time(last_registered_day / 365, last_registered_day % 365)

func _on_main_ui_change_speed(new_speed):
	match new_speed:
		0:
			speed = 0
		1:
			speed = 2
		2:
			speed = 4
		3:
			speed = 6
