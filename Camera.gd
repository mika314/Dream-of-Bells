extends Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var CAM_SPEED = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Vector3()
	
	if Input.is_action_pressed("ui_page_up"):
		dir.y += 1
	if Input.is_action_pressed("ui_page_down"):
		dir.y -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.z += 1
	if Input.is_action_pressed("ui_up"):
		dir.z -= 1
	dir = dir.rotated(Vector3(0, 1, 0), rotation.y)
	translation += dir * CAM_SPEED * delta

var MOUSE_SENSITIVITY = 0.07

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var tmpRotation = rotation;
		tmpRotation.x -= deg2rad(event.relative.y * MOUSE_SENSITIVITY)
		tmpRotation.x = clamp(tmpRotation.x, -PI / 2, +PI / 2)
		tmpRotation.y -= deg2rad(event.relative.x * MOUSE_SENSITIVITY)
		while tmpRotation.y > 2 * PI:
			tmpRotation.y -= 2 * PI
		while tmpRotation.y < -2 * PI:
			tmpRotation.y += 2 * PI
		rotation = tmpRotation









