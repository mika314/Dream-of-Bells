extends Spatial

var levels = [
"""{
	"map": [
		"  C      ",
		"[  [    [",
		"-] S<CDE[",
		" ] C[    ",
		"         ",
		"[   [    "
	],
	"cmds": "[>]{E>",
	"bells": "CDECCDECC",
}"""
]

enum Cmd {
	Empty, Right, Left, RightIf,
	LeftIf, Take, Put, Inc,
	Dec, BellC, BellD, BellE,
	BellF, BellG, BellA, BellB }

func addCmd(cmd, x, y):
	var mesh
	match cmd:
		Cmd.Empty:
			mesh = $CmdEmpty.duplicate()
		Cmd.Right:
			mesh = $CmdRight.duplicate()
		Cmd.Left:
			mesh = $CmdLeft.duplicate()
		Cmd.RightIf:
			mesh = $CmdRightIf.duplicate()
		Cmd.LeftIf:
			mesh = $CmdLeftIf.duplicate()
		Cmd.Take:
			mesh = $CmdTake.duplicate()
		Cmd.Put:
			mesh = $CmdPut.duplicate()
		Cmd.Inc:
			mesh = $CmdInc.duplicate()
		Cmd.Dec:
			mesh = $CmdDec.duplicate()
		Cmd.BellC:
			mesh = $CmdBellC.duplicate()
		Cmd.BellD:
			mesh = $CmdBellD.duplicate()
		Cmd.BellE:
			mesh = $CmdBellE.duplicate()
		Cmd.BellF:
			mesh = $CmdBellF.duplicate()
		Cmd.BellG:
			mesh = $CmdBellG.duplicate()
		Cmd.BellA:
			mesh = $CmdBellA.duplicate()
		Cmd.BellB:
			mesh = $CmdBellB.duplicate()
	mesh.visible = true
	mesh.translation.x = x
	mesh.translation.y = 0
	mesh.translation.z = y
	add_child(mesh)
	return mesh

var currentLevel = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var level = JSON.parse(levels[0])
	if level.error != OK:
		print("JSON parese error ", level.error_string)
		return
	var bellPos = 0
	for bellColor in level.result.bells:
		var bell = $Camera/Bell.duplicate()
		match bellColor:
			"C":
				bell.mesh = load("res://bell C.mesh")
			"D":
				bell.mesh = load("res://bell D.mesh")
			"E":
				bell.mesh = load("res://bell E.mesh")
			"F":
				bell.mesh = load("res://bell F.mesh")
			"G":
				bell.mesh = load("res://bell G.mesh")
			"A":
				bell.mesh = load("res://bell A.mesh")
			"B":
				bell.mesh = load("res://bell B.mesh")
		bell.visible = true
		bell.translate(Vector3(0, 0, -bellPos))
		bellPos += 1
		$Camera.add_child(bell)
	currentLevel.clear()
	var y = 0
	for line in level.result.map:
		var x = 0
		var raw = []
		for c in line:
			var cmd
			match c:
				" ":
					cmd = Cmd.Empty
				"]":
					cmd = Cmd.Right
				"[":
					cmd = Cmd.Left
				"}":
					cmd = Cmd.RightIf
				"{":
					cmd = Cmd.LeftIf
				"<":
					cmd = Cmd.Take
				">":
					cmd = Cmd.Put
				"+":
					cmd = Cmd.Inc
				"-":
					cmd = Cmd.Dec
				"C":
					cmd = Cmd.BellC
				"D":
					cmd = Cmd.BellD
				"E":
					cmd = Cmd.BellE
				"F":
					cmd = Cmd.BellF
				"G":
					cmd = Cmd.BellG
				"A":
					cmd = Cmd.BellA
				"B":
					cmd = Cmd.BellB
				"S":
					cmd = Cmd.Empty
					$Car.translation.x = x
					$Car.translation.z = y
			raw.append(addCmd(cmd, x, y))
			x += 1
		currentLevel.append(raw)
		y += 1
		execCommand()

func execCommand():
	var x = round($Car.translation.x)
	var y = round($Car.translation.z)
	if y >= currentLevel.size():
		$Car.moveForward()
		return
	if x >= currentLevel[y].size():
		$Car.moveForward()
	var cmd = currentLevel[y][x]
	cmd.exec($Car)

func _on_Car_animation_ended():
	execCommand()
