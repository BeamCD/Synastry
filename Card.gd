extends Control
var hover: bool = false
@onready var scale_value: Vector2 = scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hover && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		hover = false
		# Insert card function here or whateva
		print("card triggers")
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(self, "position", Vector2(position.x, position.y - 500), .5)
		tween.tween_callback(get_parent().queue_free)


func _on_gui_input(event):
	if not event is InputEventMouseMotion: return
	
	var angle_x_max = 15
	var angle_y_max = 20
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	
	# Normalize mouse position to the range [-1, 1] 
	var norm_x: float = (mouse_pos.x / size.x) * 2.0 - 1.0
	var norm_y: float = (mouse_pos.y / size.y) * 2.0 - 1.0
	
	# Calculate rotation angles based on normalized mouse position
	var rot_x: float = -norm_y * angle_x_max
	var rot_y: float = norm_x * angle_y_max
	
	# Apply the calculated rotations to the shader parameters
	material.set_shader_parameter("x_rot", rot_x)
	material.set_shader_parameter("y_rot", rot_y)


func _on_mouse_exited():
	hover = false
	
	# Reset attributes and shader parameters
	position.y += 600
	z_index = 0
	scale = Vector2(scale_value.x, scale_value.y)
	material.set_shader_parameter("x_rot", 0)
	material.set_shader_parameter("y_rot", 0)


func _on_mouse_entered():
	hover = true
	z_index = 1
	scale = Vector2(scale_value.x + 3, scale_value.y + 3)
	position.y -= 600
