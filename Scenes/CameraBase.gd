extends Node3D


const MOVE_SPEED = 0.1
const ROTATE_SPEED = 0.1



const BORDERS = [-100.0, 100.0, -100.0, 100.0]
const ZOOM_LIMITS = [25.0, 125.0]

@onready var camera = $CameraXRotation/Camera3D

@onready var target_translate = Vector3(0, 0, 0)
@onready var target_rotation = rotation.y
@onready var target_zoom = $CameraXRotation/Camera3D.position.z

var current_action = "None"

var start_mouse_mode = Input.mouse_mode
var mouse_lock_pos

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE :
			if event.pressed:
				current_action = "Rotate"
				mouse_lock_pos = event.position
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				current_action = "None"
				Input.mouse_mode = start_mouse_mode
				Input.warp_mouse(mouse_lock_pos)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				current_action = "Move"
			else:
				current_action = "None"
				Input.mouse_mode = start_mouse_mode
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom -= 5
			target_zoom = clamp(target_zoom, ZOOM_LIMITS[0], ZOOM_LIMITS[1])
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom += 5
			target_zoom = clamp(target_zoom, ZOOM_LIMITS[0], ZOOM_LIMITS[1])
	elif event is InputEventMouseMotion:
		if current_action == "Move":
			target_translate += Vector3(-event.relative.x, 0, -event.relative.y) * MOVE_SPEED
			#translate()
		elif current_action == "Rotate":
			target_rotation += event.relative.x * ROTATE_SPEED
			
		
		

func _process(delta):
	if Input.is_action_pressed("up"):
		target_translate.z -= 1
	if Input.is_action_pressed("left"):
		target_translate.x -= 1
	if Input.is_action_pressed("down"):
		target_translate.z += 1
	if Input.is_action_pressed("right"):
		target_translate.x += 1
	if Input.is_action_pressed("rotate_left"):
		target_rotation -= 2
	if Input.is_action_pressed("rotate_right"):
		target_rotation += 2
	position.x = clamp(position.x, BORDERS[0], BORDERS[1])
	position.z = clamp(position.z, BORDERS[2], BORDERS[3])
	$CameraXRotation/Camera3D.position.z = lerp($CameraXRotation/Camera3D.position.z, target_zoom, delta * 10)
	#rotation_degrees.y = lerp(rotation_degrees.y, target_rotation, delta * 10)
	rotation_degrees.y = interpolate_angle(rotation_degrees.y, target_rotation, delta * 10) # Use interpolate_angle
	var translate_value = lerp(Vector3(0, 0, 0), target_translate, delta*10)
	target_translate -= translate_value
	translate(translate_value)
func lerp(start, end, t):
	return start + (end - start) * t

func normalize_angle(angle):
	while angle < -180.0:
		angle += 360.0
	while angle > 180.0:
		angle -= 360.0
	return angle

func interpolate_angle(start_angle, target_angle, alpha):
	start_angle = normalize_angle(start_angle)
	target_angle = normalize_angle(target_angle)
	var diff = target_angle - start_angle
	if abs(diff) > 180.0:
		diff -= 360.0 * sign(diff)
	return normalize_angle(start_angle + diff * alpha)
