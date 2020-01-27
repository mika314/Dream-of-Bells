extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# warning-ignore:unused_class_variable
export var levelNum = 0
signal hover
signal click

func _on_Area_mouse_entered():
	emit_signal("hover", self, true)


func _on_Area_mouse_exited():
	emit_signal("hover", self, false)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if !event is InputEventMouseButton:
		return
	if event.pressed:
		emit_signal("click", self)
