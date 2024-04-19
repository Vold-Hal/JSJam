extends Node3D

class_name BuildingTemplate

var energy_production: float
var greenness: float
var building_time: float
var building_type: String
var building_name: String
var building_cost: float

var days_in_build: int = 0
var is_built: bool = false

var meshes
var heights = []

func _ready():
	print("saf")
	for PE in $Particles.get_children():
		PE.emitting = false
	meshes = $Model.get_child(0).get_children()
	meshes.shuffle()
	for mesh in meshes:
		heights.append(mesh.get_aabb().size.y * mesh.scale.y)

func _process(_delta):
	if !is_built:
		var completion_percent: float = days_in_build / (building_time * 365) + 0.01
		var needed_completion_for_mesh: float = 1.0 / len(meshes)
		for i in range(len(meshes)):
			pass
			meshes[i].position.y = -heights[i] * max(0, 1 - (completion_percent - needed_completion_for_mesh * i) / needed_completion_for_mesh)
			#meshes[i].position.y = 5 * min(1, ((complition_percent - needed_complition_for_mesh) / (needed_complition_for_mesh * i)))

func next_day():
	if is_built:
		return energy_production
	else:
		days_in_build += 1
		if days_in_build >= building_time * 365:
			is_built = true
			for PE in $Particles.get_children():
				PE.emitting = true
	return 0
