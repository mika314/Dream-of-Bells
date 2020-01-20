extends MeshInstance

var animation

class MoveForward:
	var car
	var dest
	var dir
	var CAR_SPEED = 1
	func _init(aCar):
		car = aCar
		dir = Vector3(0, 0, -1)
		dir = dir.rotated(Vector3(0, 1, 0), car.rotation.y)
		dest = car.translation + dir
	func run(delta):
		car.translation += dir * delta * CAR_SPEED
		if (car.translation - dest).length() < 0.03:
			car.translation = dest
			return false
		return true
		

class Rotate:
	var CAR_ROTATION_SPEED = 1
	var dest
	var car
	func _init(aCar, aDest):
		car = aCar
		dest = aDest
	func run(delta):
		var dir = dest - car.rotation.y
		if dir > PI:
			dir -= 2 * PI
		if dir < -PI:
			dir += 2 * PI
		if abs(dir) < 0.03:
			car.rotation.y = dest
			car.animation = MoveForward.new(car)
			return true
		if dir > 0:
			car.rotation.y += CAR_ROTATION_SPEED * delta
		else:
			car.rotation.y -= CAR_ROTATION_SPEED * delta
		return true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
signal animation_ended

func rotateLeft():
	animation = Rotate.new(self, rotation.y + PI / 2)
	
func rotateRight():
	animation = Rotate.new(self, rotation.y - PI / 2)
	
func moveForward():
	animation = MoveForward.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation:
		if !animation.run(delta):
			animation = null
			emit_signal("animation_ended")
