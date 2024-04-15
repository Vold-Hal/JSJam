extends TileMap

var grid_size: int = 30 #16x30
var tiles_dic: Dictionary = {}

func _ready():
	
	for x in grid_size:
		for y in grid_size:
			tiles_dic[str(Vector2(x, y))] = {
				"Type": "Grass",
				"Building": "None"
			}
			set_cell(0, Vector2(x, y) , 0, Vector2i(0, 0), 0)

func _process(delta):
	var tile_coords: Vector2 = local_to_map(get_global_mouse_position())
	
	for x in grid_size:
		for y in grid_size:
			erase_cell(1, Vector2(x,y))
	
	if tiles_dic.has(str(tile_coords)):
		set_cell(1, tile_coords , 0, Vector2i(1, 0), 0)
