extends Node3D

const EVENT_BASE_CHANCE = 0.00001

var event_chance = EVENT_BASE_CHANCE * 50
var last_event_day = 0
var previus_speed
var current_speed


@onready var event_window = $MainUI/EventUI

var day: float = 0
@export var speed: int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var last_registered_day: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	day += speed * delta
	while day - last_registered_day > 1:
		next_day()


func next_day():
	if randf() < event_chance:
		print("Event at day " + str(last_registered_day))
		event_window.new_event()
		if is_instance_valid($GridMap.building_UI):
			$GridMap.building_UI.queue_free()
		$GridMap.choosen_coords = Vector3i.MIN
		previus_speed = current_speed
		$MainUI._on_pause_button_pressed()
		$EventAudioPlayer.play()
		event_chance = EVENT_BASE_CHANCE
	else:
		event_chance *= 1.003
	last_registered_day += 1
	$Buildings.next_day()
	$MainUI.update_time(last_registered_day / 365, last_registered_day % 365)

func _on_main_ui_change_speed(new_speed):
	current_speed = new_speed
	match new_speed:
		0:
			speed = 0
		1:
			speed = 2
		2:
			speed = 20
		3:
			speed = 50

func change_speed_back():
	$EventAudioPlayer.play()
	match previus_speed:
		1: 
			$MainUI._on_speed_1_button_pressed()
		2: 
			$MainUI._on_speed_2_button_pressed()
		3: 
			$MainUI._on_speed_3_button_pressed()
