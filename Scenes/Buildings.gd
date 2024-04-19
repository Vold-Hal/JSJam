extends Node3D

var power_plants: Array[PackedScene] = [preload("res://Scenes/coal_power_plant.tscn"), preload("res://Scenes/solar_power_plant.tscn"), preload("res://Scenes/nuclear_power_plant.tscn")]

func start_building_process(building_name: String):
	print(building_name)
	var building
	if building_name == "Coal Power Plant":
		building = power_plants[0].instantiate()
	elif building_name == "Solar Power Plant":
		building = power_plants[1].instantiate()
	elif building_name == "Nuclear Power Plant":
		building = power_plants[2].instantiate()
		
	self.add_child(building)
	building.rotation.y += deg_to_rad(90 * (randi() % 4))
	building.global_position = $"../GridMap".request_building_start()

func next_day():
	var production: float = 0
	for building in get_children():
		if building.building_type == "PowerPlant":
			production += building.next_day()
	$"../MainUI".update_energy(production)
