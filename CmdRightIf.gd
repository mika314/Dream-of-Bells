extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.stream.loop = false
	$Wrong.stream.loop = false

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	var tmpCmd = cmdForwardRight.cmd if cmdForwardRight else Cmd.Empty
	if tmpCmd != car.roof:
		$Wrong.play()
		car.moveForward()
	else:
		$AudioStreamPlayer3D.play()
		car.rotateRight()
	return tmpCmd == car.roof

#warning-ignore:unused_class_variable
export var cmd = Cmd.RightIf
