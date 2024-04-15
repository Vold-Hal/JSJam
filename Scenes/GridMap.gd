extends Node3D

var grid_size: int = 4
var tiles_dic: Dictionary = {} # Dictionary to store tile positions

func _ready():
	# Initialize tiles_dic with grid positions
	for x in range(grid_size):
		for y in range(grid_size):
			tiles_dic[str(x, y)] = {
				"Empty": true
			}

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Get the mouse position in the scene
			var camera = $"../Camera3D"
			var ray_origin = camera.project_ray_origin(event.position)
			var ray_end = ray_origin + camera.project_ray_normal(event.position) * 1000 # Adjust this distance as needed
			
			# Perform a raycast to detect collisions
			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
			if result:
				var collision_point = result.position
				print(collision_point)
				var coord = $".".local_to_map(collision_point) + Vector3i.DOWN
				$".".set_cell_item(coord, 1)
				print(coord)



