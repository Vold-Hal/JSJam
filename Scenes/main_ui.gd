extends Control

signal screen_touched
signal change_speed(int)

var old_popularity = 0
var old_control_percent = 0

@onready var money_label = $TopBar/TextureRect/MarginContainer/HBoxContainer/MoneyContainer/HSplitContainer/MoneyLabel
@onready var income_label = $TopBar/TextureRect/MarginContainer/HBoxContainer/MoneyContainer/HSplitContainer/MarginContainer/IncomeLabel
@onready var energy_label = $TopBar/TextureRect/MarginContainer/HBoxContainer/EnergyContainer/HSplitContainer/EnergyLabel
@onready var surplus_label = $TopBar/TextureRect/MarginContainer/HBoxContainer/EnergyContainer/HSplitContainer/MarginContainer/SurplusLabel
@onready var time_label =  $TopBar/TextureRect/MarginContainer/HBoxContainer/TimeContainer/HSplitContainer/TimeLabel
@onready var popularity_bar = $TopBar/TextureRect/MarginContainer/HBoxContainer/PopularityContainer/HBoxContainer/PopularityBar
@onready var popularity_arrow = $TopBar/TextureRect/MarginContainer/HBoxContainer/PopularityContainer/HBoxContainer/TextureRect
@onready var control_percent_label = $TopBar/TextureRect/MarginContainer/HBoxContainer/ControlContainer/HSplitContainer/ControlLabel
@onready var control_percent_arrow = $TopBar/TextureRect/MarginContainer/HBoxContainer/ControlContainer/HSplitContainer/TextureRect2
@onready var speed_buttons_parent = $TopBar/TextureRect/MarginContainer/HBoxContainer/TimeContainer/MarginContainer/SpeedControl

func _ready():
	_on_speed_1_button_pressed()

func _process(delta):
	if Input.is_action_pressed("pause"):
		_on_pause_button_pressed()
	elif Input.is_action_pressed("speed1"):
		_on_speed_1_button_pressed()
	elif Input.is_action_pressed("speed2"):
		_on_speed_2_button_pressed()
	elif Input.is_action_pressed("speed3"):
		_on_speed_3_button_pressed()

func update_time(year: int, day: int):
	time_label.text = "year " + str(year) + ", day " + str(day)


func update_energy(production: float, satisfaction: float, surplus: float, money: float, income: float, popularity: float, control_percent: float):
	money_label.text = format(int(money * 1000000))
	
	if income >= 0:
		income_label.text = "+" + format(int(income * 1000000))
		income_label.modulate = Color("#007000")
	else:
		income_label.text = "-" + format(int(-income * 1000000))
		income_label.modulate = Color("#ae0010")
		
	
	energy_label.text = format(int(production)) + "MWd"
	
	if surplus >= 0:
		surplus_label.text = "/" + format(int(production - surplus)) + "MWd"
		surplus_label.modulate = Color("#007000")
	else:
		surplus_label.text = "/" + format(int(production - surplus)) + "MWd"
		surplus_label.modulate = Color("#ae0010")
	
	
	var popularity_percent = popularity / 5
	popularity_bar.modulate = get_color_on_scale(Color("#ae0010"), Color("#007000"), popularity_percent)
	popularity_bar.value = popularity
	if popularity < old_popularity:
		popularity_arrow.flip_v = true
		popularity_arrow.modulate = Color("#ae0010")
	elif popularity > old_popularity:
		popularity_arrow.flip_v = false
		popularity_arrow.modulate = Color("#007000")
	old_popularity = popularity
	
	control_percent_label.text = "%2.1f" % (control_percent * 100)
	if control_percent < old_control_percent:
		control_percent_arrow.flip_v = true
		control_percent_arrow.modulate = Color("#ae0010")
	elif control_percent > old_control_percent:
		control_percent_arrow.flip_v = false
		control_percent_arrow.modulate = Color("#007000")
	old_control_percent = control_percent

func _on_screen_btn_button_up():
	screen_touched.emit()

func format(n):
	n = str(n)
	var size = n.length()
	var s = ""
	
	for i in range(size):
		if((size - i) % 3 == 0 and i > 0):
			s = str(s," ", n[i])
		else:
			s = str(s,n[i])
	
	return s

func get_color_on_scale(color1: Color, color2: Color, position: float) -> Color:
	var r = color1.r + (color2.r - color1.r) * position
	var g = color1.g + (color2.g - color1.g) * position
	var b = color1.b + (color2.b - color1.b) * position
	return Color(r, g, b)


func _on_pause_button_pressed():
	change_speed.emit(0)
	change_speed_btn(0)
func _on_speed_1_button_pressed():
	change_speed.emit(1)
	change_speed_btn(1)
func _on_speed_2_button_pressed():
	change_speed.emit(2)
	change_speed_btn(2)
func _on_speed_3_button_pressed():
	change_speed.emit(3)
	change_speed_btn(3)
	
func change_speed_btn(index):
	for btn in speed_buttons_parent.get_children():
		btn.button_pressed = false
	speed_buttons_parent.get_children()[index].button_pressed = true
