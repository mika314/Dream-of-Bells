extends MeshInstance

func _ready():
	pass # Replace with function body.

func hover(value):
	visible = value

signal play

func left_click():
	emit_signal("play")

func right_click():
	pass # Replace with function body.
