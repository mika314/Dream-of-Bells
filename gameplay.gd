extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var eyesOpen
var eyesClosed

enum Cmd {
	Empty, Right, Left, RightIf,
	LeftIf, Take, Put, Inc,
	Dec, BellC, BellD, BellE,
	BellF, BellG, BellA, BellB }

func addCmd(cmd, x, y):
	var mesh = MeshInstance.new()
	match cmd:
		Cmd.Empty:
			mesh.mesh = load("res://cmd 00 empty.mesh");
		Cmd.Right:
			mesh.mesh = load("res://cmd 01 right.mesh");
		Cmd.Left:
			mesh.mesh = load("res://cmd 02 left.mesh");
		Cmd.RightIf:
			mesh.mesh = load("res://cmd 03 right if.mesh");
		Cmd.LeftIf:
			mesh.mesh = load("res://cmd 04 left if.mesh");
		Cmd.Take:
			mesh.mesh = load("res://cmd 05 take.mesh");
		Cmd.Put:
			mesh.mesh = load("res://cmd 06 put.mesh");
		Cmd.Inc:
			mesh.mesh = load("res://cmd 07 inc.mesh");
		Cmd.Dec:
			mesh.mesh = load("res://cmd 08 dec.mesh");
		Cmd.BellC:
			mesh.mesh = load("res://cmd 09 bell C.mesh");
		Cmd.BellD:
			mesh.mesh = load("res://cmd 10 bell D.mesh");
		Cmd.BellE:
			mesh.mesh = load("res://cmd 11 bell E.mesh");
		Cmd.BellF:
			mesh.mesh = load("res://cmd 12 bell F.mesh");
		Cmd.BellG:
			mesh.mesh = load("res://cmd 13 bell G.mesh");
		Cmd.BellA:
			mesh.mesh = load("res://cmd 14 bell A.mesh");
		Cmd.BellB:
			mesh.mesh = load("res://cmd 15 bell B.mesh");
	mesh.translation.x = x
	mesh.translation.z = y
	add_child(mesh)

# Called when the node enters the scene tree for the first time.
func _ready():
	eyesOpen = MeshInstance.new()
	eyesOpen.mesh = load("res://eyes open.mesh")
	eyesClosed = MeshInstance.new()
	eyesClosed.mesh = load("res://eyes closed.mesh")
	eyesClosed.visible = false
	var bellD = MeshInstance.new()
	bellD.add_child(eyesOpen)
	bellD.add_child(eyesClosed)
	bellD.mesh = load("res://bell C.mesh")
	bellD.translation.x = -3
	bellD.translation.y = 2
	bellD.translation.z = -4.5
	bellD.rotate_y(-PI / 2)
	$Camera.add_child(bellD)
	for x in range(1, 10):
		for y in range(1, 10):
			addCmd(Cmd.Empty, x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camSpeed = 2
	if Input.is_action_pressed("ui_right"):
		$Camera.translation.z -= camSpeed * delta
	if Input.is_action_pressed("ui_left"):
		$Camera.translation.z += camSpeed * delta
	if Input.is_action_pressed("ui_down"):
		$Camera.translation.x += camSpeed * delta
	if Input.is_action_pressed("ui_up"):
		$Camera.translation.x -= camSpeed * delta

func _on_Timer_timeout():
	eyesOpen.visible = !eyesOpen.visible
	eyesClosed.visible = !eyesClosed.visible
