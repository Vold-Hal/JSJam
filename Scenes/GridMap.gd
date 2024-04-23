extends Node3D


var occupied: Array = [] # Dictionary to store tile positions

var building_UI_scene = preload("res://Scenes/building_ui.tscn")
var building_UI
var choosen_coords: Vector3i = Vector3i.MIN
var last_mouse_click_position

func _mouse_clicked_on_screen():
	if choosen_coords == Vector3i.MIN:
		if choose_new_coords():
			open_building_menu()
	else:
		building_UI.queue_free()
		choosen_coords = Vector3i.MIN

func choose_new_coords():
	# Get the mouse position in the scene
	var camera = $"../CameraBase/CameraXRotation/Camera3D"
	var ray_origin = camera.project_ray_origin(last_mouse_click_position)
	var ray_end = ray_origin + camera.project_ray_normal(last_mouse_click_position) * 1000 # Adjust this distance as needed
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	if result:
		var collision_point = result.position
		choosen_coords = $".".local_to_map(collision_point) + Vector3i.DOWN
		if $".".get_cell_item(choosen_coords) == 0 && choosen_coords not in occupied:
			return true
	choosen_coords = Vector3i.MIN
	return false

func open_building_menu():
	building_UI = building_UI_scene.instantiate()
	$"../MainUI".add_child(building_UI)
	var arr = $"../Buildings".power_plants
	building_UI.display_building_options(arr)
	building_UI.global_position = last_mouse_click_position 

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			last_mouse_click_position = event.position

func request_building_start():
	occupied.append(choosen_coords)
	var return_coords = $".".map_to_local(choosen_coords + Vector3i.UP)
	choosen_coords = Vector3i.MIN
	if building_UI:
		building_UI.queue_free()
	return return_coords
