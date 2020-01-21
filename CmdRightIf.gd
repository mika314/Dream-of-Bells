extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.stream.loop = false

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	var cmd = cmdForwardRight.cmd if cmdForwardRight else Cmd.Empty
	if cmd == car.roof:
		car.moveForward()
	else:
		car.rotateRight()

#warning-ignore:unused_class_variable
export var cmd = Cmd.RightIf
