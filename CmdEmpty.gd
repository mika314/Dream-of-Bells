extends CmdBlock

# Called when the node enters the scene tree for the first time.
func _ready():
	cmd = Cmd.Empty

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	car.moveForward()

