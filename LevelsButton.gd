extends MeshInstance

func _ready():
	pass # Replace with function body.

func hover(value):
	visible = value

signal levels

func left_click():
	emit_signal("levels")

func right_click():
	pass # Replace with function body.
