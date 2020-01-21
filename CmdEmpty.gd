extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	car.moveForward()

#warning-ignore:unused_class_variable
export var cmd = Cmd.Empty
