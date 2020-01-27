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

var onRoofMeshes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	onRoofMeshes[Cmd.Empty] = MeshInstance.new()
	onRoofMeshes[Cmd.Right] = load("res://roof 01 right.mesh")
	onRoofMeshes[Cmd.Left] = load("res://roof 02 left.mesh")
	onRoofMeshes[Cmd.RightIf] = load("res://roof 03 right if.mesh")
	onRoofMeshes[Cmd.LeftIf] = load("res://roof 04 left if.mesh")
	onRoofMeshes[Cmd.Take] = load("res://roof 05 take.mesh")
	onRoofMeshes[Cmd.Put] = load("res://roof 06 put.mesh")
	onRoofMeshes[Cmd.Inc] = load("res://roof 07 inc.mesh")
	onRoofMeshes[Cmd.Dec] = load("res://roof 08 dec.mesh")
	onRoofMeshes[Cmd.BellC] = load("res://roof 09 bell C.mesh")
	onRoofMeshes[Cmd.BellD] = load("res://roof 10 bell D.mesh")
	onRoofMeshes[Cmd.BellE] = load("res://roof 11 bell E.mesh")
	onRoofMeshes[Cmd.BellF] = load("res://roof 12 bell F.mesh")
	onRoofMeshes[Cmd.BellG] = load("res://roof 13 bell G.mesh")
	onRoofMeshes[Cmd.BellA] = load("res://roof 14 bell A.mesh")
	onRoofMeshes[Cmd.BellB] = load("res://roof 15 bell B.mesh")

signal animation_ended

func rotateLeft():
	animation = Rotate.new(self, rotation.y + PI / 2)
	
func rotateRight():
	animation = Rotate.new(self, rotation.y - PI / 2)
	
func moveForward():
	animation = MoveForward.new(self)

#warning-ignore:unused_class_variable
var roof = Cmd.Empty

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation:
		if !animation.run(delta):
			animation = null
			emit_signal("animation_ended")

func getForwardRightCoord():
	var dir = Vector3(0, 0, -1)
	dir = dir.rotated(Vector3(0, 1, 0), rotation.y)
	var dest = translation + dir
	dir = dir.rotated(Vector3(0, 1, 0), -PI / 2)
	dest = dest + dir
	return Vector2(round(dest.x), round(dest.z))

func setRoof(cmd):
	roof = cmd
	$OnRoofCmd.mesh = onRoofMeshes[roof]
	playRestAnim()

func inc():
	moveForward()
	var tmp = roof
	tmp += 1
	tmp %= 16
	setRoof(tmp)

func dec():
	moveForward()
	var tmp = roof
	tmp += 15
	tmp %= 16
	setRoof(tmp)

func take(cmd):
	moveForward()
	roof = cmd.cmd if cmd else Cmd.Empty
	$OnRoofCmd.mesh = onRoofMeshes[roof]
	$OnRoofCmd/AnimationPlayer.play("jump on the roof")

func put():
	moveForward()
	$OnRoofCmd/AnimationPlayer.play("jump from the roof")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump from the roof":
		$OnRoofCmd.mesh = onRoofMeshes[roof]
	playRestAnim()

func playRestAnim():
	match roof:
		Cmd.Empty:
			$OnRoofCmd/AnimationPlayer.play("rest")
		Cmd.Right:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.Left:
			$OnRoofCmd/AnimationPlayer.play("left")
		Cmd.RightIf:
			$OnRoofCmd/AnimationPlayer.play("rest")
		Cmd.LeftIf:
			$OnRoofCmd/AnimationPlayer.play("rest")
		Cmd.Take:
			$OnRoofCmd/AnimationPlayer.play("rest")
		Cmd.Put:
			$OnRoofCmd/AnimationPlayer.play("rest")
		Cmd.Inc:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.Dec:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellC:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellD:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellE:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellF:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellG:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellA:
			$OnRoofCmd/AnimationPlayer.play("right")
		Cmd.BellB:
			$OnRoofCmd/AnimationPlayer.play("right")

var initX: int
var initY: int

func setInitPos(x: int, y: int):
	initX = x
	initY = y
	reset()

func reset():
	translation.x = initX
	translation.z = initY
	setRoof(Cmd.Empty)
	rotation = Vector3(0, -PI / 2, 0)
	animation = null
