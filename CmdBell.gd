extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.stream.loop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func exec(car):
	$AudioStreamPlayer3D.play()
	car.moveForward()