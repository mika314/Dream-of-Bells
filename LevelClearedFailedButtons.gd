extends MeshInstance

signal click

enum { Levels, Restart, Next }

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hover(value):
	pass

func left_click():
	pass

func right_click():
	pass

func _on_Area_mouse_entered():
	$"../frame".visible = true
	$"../frame".translation = translation

func _on_Area_mouse_exited():
	$"../frame".visible = false

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if !event is InputEventMouseButton:
		return
	if event.pressed:
		emit_signal("click")
