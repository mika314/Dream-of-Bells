extends MeshInstance

func _ready():
	pass # Replace with function body.

func hover(value):
	visible = value

signal stop

func left_click():
	emit_signal("stop")

func right_click():
	pass # Replace with function body.
