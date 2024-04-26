extends Control

var building_options: Array
var ready_to_build: bool = false





func display_building_options(options: Array[PackedScene]):
	ready_to_build = false
	building_options = options
	while options.size() > $BuildingMenu.get_child_count():
		$BuildingMenu.add_child($BuildingMenu.get_children()[-1].duplicate())
		print("Duplicated")
	var i = 0
	for option in building_options:
		option = option.instantiate()
		$BuildingMenu.get_children()[i].get_child(1).button_down.connect(choose_building_option.bind(option.building_name, option.building_cost))
		var text_node = $BuildingMenu.get_children()[i].get_child(0).get_child(0)
		text_node.get_child(0).text = option.building_name
		text_node.get_child(1).get_child(0).text = "Building time: " + str(option.building_time) + " year(s)" + "\nProduction: " + str(option.energy_production) + "MWd" 
		text_node.get_child(1).get_child(1).text = "Cost: " + str(option.building_cost) + " 000 000" + "\nUpkeep cost: " + str(option.building_upkeep_cost * 1000) + " 000"
		i += 1
		option.free()
	await get_tree().create_timer(0.2).timeout
	ready_to_build = true
	

func _ready():
	$WarningLabel.modulate.a = 0
	
func choose_building_option(building_name, cost):
	if $"../../Buildings".money >= cost:
		$"../../Buildings".money -= cost
		$"../../Buildings".start_building_process(building_name)
	else: 
		$WarningLabel/AnimationPlayer.play("text_move")

		

