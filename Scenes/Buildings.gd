extends Node3D

const POPULARITY_DRIFT_RATE: float = 0.003
const REQUIRED_GROWTH_RATE: float = 0.1
const CONTROL_DRIFT_RATE: float = 0.000035
const BASE_MWd_price: float = 0.0003

var is_finished = false
var green_production_multiplier = 1.0
var green_upkeep_multiplier = 1.0
var upkeep_multiplier = 1.0
var solar_upkeep_multiplier = 1.0
var solar_production_multiplier = 1.0
var nuclear_upkeep_multiplier = 1.0
var nuclear_production_multiplier = 1.0
var coal_upkeep_multiplier = 1.0
var energy_price_multiplier = 1.0
var nongreen_upkeep_multiplier = 1.0
var green_price_bonus = 0.0
var money: float = 2.5
var production_multiplier = 1.0
var required_power: float = 550
var control_percent: float = 0.05
var popularity: float = 2
var surplus: float = 0
var nongreen_production_multiplier = 1.0

func _ready():
	$"../GridMap".choosen_coords = Vector3i(1, 0, 1)
	var starting_power_plant = start_building_process("Coal Power Plant")
	starting_power_plant.days_in_build = starting_power_plant.building_time * 365 - 1

var endscreen_scene = preload("res://Scenes/end_screen.tscn")
var power_plants: Array[PackedScene] = [preload("res://Scenes/solar_power_plant.tscn"), preload("res://Scenes/wind_power_plant.tscn"), preload("res://Scenes/coal_power_plant.tscn"), preload("res://Scenes/nuclear_power_plant.tscn")]

func start_building_process(building_name: String):
	$"../BuiltAudioPlayer".play()
	print(building_name)
	var building
	if building_name == "Coal Power Plant":
		building = power_plants[2].instantiate()
	elif building_name == "Solar Power Plant":
		building = power_plants[0].instantiate()
	elif building_name == "Nuclear Power Plant":
		building = power_plants[3].instantiate()
	elif building_name == "Wind Power Plant":
		building = power_plants[1].instantiate()
		
	self.add_child(building)
	if building_name != "Solar Power Plant" && building_name != "Wind Power Plant":
		building.rotation.y += deg_to_rad(90 * (randi() % 4))
	building.global_position = $"../GridMap".request_building_start(building)
	return building

func next_day():
	var MWd_price = BASE_MWd_price * energy_price_multiplier
	var income = 0.0
	var production: float = 0
	
	var green_production = 0.0
	
	
	for building in get_children():
		if building.building_type == "PowerPlant":
			var this_production = building.next_day()
			
			if building.greenness > 0:
				if building.building_name == "Nuclear Power Plant":
					green_production += this_production * ((nuclear_production_multiplier + green_production_multiplier)/2)
					income -= building.building_upkeep_cost * ((nuclear_upkeep_multiplier + upkeep_multiplier + green_upkeep_multiplier)/3)
				elif building.building_name == "Solar Power Plant":
					green_production += this_production * ((solar_production_multiplier + green_production_multiplier)/2)
					income -= building.building_upkeep_cost * ((solar_upkeep_multiplier + upkeep_multiplier + green_upkeep_multiplier)/3)
				else:
					green_production += this_production * green_production_multiplier
					income -= building.building_upkeep_cost * ((upkeep_multiplier + green_upkeep_multiplier)/2)
			else:
				this_production *= nongreen_production_multiplier
				income -= building.building_upkeep_cost * ((nongreen_upkeep_multiplier + coal_upkeep_multiplier)/2)
			production += this_production * production_multiplier


	
	var green_percent = 0.0
	if production != 0:
		green_percent = green_production / production
	
	surplus = production - required_power * control_percent
	var surplus_percent = surplus / (required_power * control_percent)
	
	var unclamped_surplus_percent = surplus_percent
	surplus_percent = clamp(surplus_percent, -0.3, 0.5)

	required_power += max(REQUIRED_GROWTH_RATE * 0.01, REQUIRED_GROWTH_RATE * surplus_percent * control_percent)

	if surplus_percent > 0:
		income += required_power * control_percent * MWd_price + required_power * control_percent * green_percent * green_price_bonus * MWd_price
		income += 0.5 * ((production - required_power * control_percent) * MWd_price + (production - required_power * control_percent) * green_percent * green_price_bonus * MWd_price)
	else:
		income += production * MWd_price + production * green_percent * green_price_bonus * MWd_price
	money += income
	
	
	surplus_percent = clamp(surplus_percent, -0.3, 0.3)
	popularity += surplus_percent * POPULARITY_DRIFT_RATE
	popularity = clamp(popularity, 0.0, 5)
	control_percent += (popularity - 2) * CONTROL_DRIFT_RATE
	
	if control_percent <= 0 && !is_finished:
		is_finished = true
		$"../MainUI"._on_pause_button_pressed()
		var endscreen = endscreen_scene.instantiate()
		$"../MainUI".add_child(endscreen)
		endscreen.get_result("lose")
	elif control_percent >= 1 && !is_finished:
		is_finished = true
		$"../MainUI"._on_pause_button_pressed()
		var endscreen = endscreen_scene.instantiate()
		$"../MainUI".add_child(endscreen)
		endscreen.get_result("win")
	
	$"../MainUI".update_energy(production, 1 + unclamped_surplus_percent, surplus, money, income, popularity, control_percent)
