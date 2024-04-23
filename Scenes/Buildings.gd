extends Node3D

const POPULARITY_DRIFT_RATE: float = 0.003
const REQUIRED_GROWTH_RATE: float = 0.1
const CONTROL_DRIFT_RATE: float = 0.000035


var money: float = 2.5
var MWd_price: float = 0.0002
var required_power: float = 550
var control_percent: float = 0.05
var popularity: float = 2
var surplus: float = 0

func _ready():
	$"../GridMap".choosen_coords = Vector3i(1, 0, 1)
	var starting_power_plant = start_building_process("Coal Power Plant")
	starting_power_plant.days_in_build = starting_power_plant.building_time * 365 - 1

var power_plants: Array[PackedScene] = [preload("res://Scenes/solar_power_plant.tscn"), preload("res://Scenes/wind_power_plant.tscn"), preload("res://Scenes/coal_power_plant.tscn"), preload("res://Scenes/nuclear_power_plant.tscn")]

func start_building_process(building_name: String):
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
	building.global_position = $"../GridMap".request_building_start()
	return building

func next_day():
	var income = 0.0
	var production: float = 0
	for building in get_children():
		if building.building_type == "PowerPlant":
			production += building.next_day()
			income -= building.building_upkeep_cost

	
	surplus = production - required_power * control_percent
	var surplus_percent = surplus / (required_power * control_percent)
	
	var unclamped_surplus_percent = surplus_percent
	surplus_percent = clamp(surplus_percent, -0.3, 0.5)

	required_power += max(REQUIRED_GROWTH_RATE * 0.01, REQUIRED_GROWTH_RATE * surplus_percent * control_percent)
	
	
	if surplus_percent > 0:
		income += required_power * control_percent * MWd_price
		income += (production - required_power * control_percent) * MWd_price * 0.5
	else:
		income += production * MWd_price
	money += income
	
	
	surplus_percent = clamp(surplus_percent, -0.3, 0.3)
	popularity += surplus_percent * POPULARITY_DRIFT_RATE
	popularity = clamp(popularity, 0.1, 5)
	control_percent += (popularity - 2) * CONTROL_DRIFT_RATE
	
	
	
	$"../MainUI".update_energy(production, 1 + unclamped_surplus_percent, surplus, money, income, popularity, control_percent)
