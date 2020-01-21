extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.stream.loop = false

#warning-ignore:unused_argument
func exec(car, cmdForwardRight):
	$AudioStreamPlayer3D.play()
	car.rotateLeft()

#warning-ignore:unused_class_variable
export var cmd = Cmd.Left
