extends Control
var hover: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("card triggers")


func _on_texture_rect_mouse_exited():
	material.set_shader_parameter("x_rot", 0)
	material.set_shader_parameter("y_rot", 0)


func _on_gui_input(event):
	if not event is InputEventMouseMotion: return
	hover = true
	
	var angle_x_max = 15
	var angle_y_max = 20
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	
	# Normalize mouse position to the range [-1, 1] instead of [0, 1]
	var norm_x: float = (mouse_pos.x / size.x) * 2.0 - 1.0
	var norm_y: float = (mouse_pos.y / size.y) * 2.0 - 1.0
	
	# Calculate rotation angles based on normalized mouse position
	var rot_x: float = -norm_y * angle_x_max
	var rot_y: float = norm_x * angle_y_max
	
	# Apply the calculated rotations to the shader parameters
	material.set_shader_parameter("x_rot", rot_x)
	material.set_shader_parameter("y_rot", rot_y)


func _on_mouse_exited():
	material.set_shader_parameter("x_rot", 0)
	material.set_shader_parameter("y_rot", 0)
