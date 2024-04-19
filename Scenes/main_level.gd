extends Node3D

var day: float = 0
var year: int = 0
var speed: int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var last_registered_day: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	day += speed * speed * delta
	if day - last_registered_day > 1:
		next_day()
	if day > 365:
		year += 1 
		day -= 365
		last_registered_day = 0
	


func next_day():
	last_registered_day += 1
	$Buildings.next_day()
	$MainUI.update_time(year, int(last_registered_day))

