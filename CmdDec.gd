extends CmdBlock

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.stream.loop = false
	cmd = Cmd.Dec

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	$AudioStreamPlayer3D.play()
	car.dec()

