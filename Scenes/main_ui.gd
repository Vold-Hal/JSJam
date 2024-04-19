extends Control

signal screen_touched

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_time(year: int, day: int):
	$timeLabel.text = "year:" + str(year) + " day:" + str(day)

func update_energy(production: float):
	$energyLabel.text = "MWd: " + str(production)

func _on_screen_btn_button_up():
	screen_touched.emit()
