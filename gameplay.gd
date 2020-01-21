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

func addCmd(cmd, x, y):
	var cmdBlock
	match cmd:
		Cmd.Empty:
			cmdBlock = $CmdEmpty.duplicate()
		Cmd.Right:
			cmdBlock = $CmdRight.duplicate()
		Cmd.Left:
			cmdBlock = $CmdLeft.duplicate()
		Cmd.RightIf:
			cmdBlock = $CmdRightIf.duplicate()
		Cmd.LeftIf:
			cmdBlock = $CmdLeftIf.duplicate()
		Cmd.Take:
			cmdBlock = $CmdTake.duplicate()
		Cmd.Put:
			cmdBlock = $CmdPut.duplicate()
		Cmd.Inc:
			cmdBlock = $CmdInc.duplicate()
		Cmd.Dec:
			cmdBlock = $CmdDec.duplicate()
		Cmd.BellC:
			cmdBlock = $CmdBellC.duplicate()
		Cmd.BellD:
			cmdBlock = $CmdBellD.duplicate()
		Cmd.BellE:
			cmdBlock = $CmdBellE.duplicate()
		Cmd.BellF:
			cmdBlock = $CmdBellF.duplicate()
		Cmd.BellG:
			cmdBlock = $CmdBellG.duplicate()
		Cmd.BellA:
			cmdBlock = $CmdBellA.duplicate()
		Cmd.BellB:
			cmdBlock = $CmdBellB.duplicate()
	cmdBlock.visible = true
	cmdBlock.translation.x = x
	cmdBlock.translation.y = 0
	cmdBlock.translation.z = y
	add_child(cmdBlock)
	return cmdBlock

var bells = []
var currentLevel = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = JSON.parse(levels[0])
	if level.error != OK:
		print("JSON parese error ", level.error_string)
		return
	var bellPos = 0
	for bellColor in level.result.bells:
		var bell = $Camera/Bell.duplicate()
		bell.mesh = load("res://bell " + bellColor + ".mesh")
		bell.visible = true
		bell.translate(Vector3(0, 0, -bellPos))
		match bellColor:
			"C":
				  bell.cmd = Cmd.BellC
			"D":
				  bell.cmd = Cmd.BellD
			"E":
				  bell.cmd = Cmd.BellE
			"F":
				  bell.cmd = Cmd.BellF
			"G":
				  bell.cmd = Cmd.BellG
			"A":
				  bell.cmd = Cmd.BellA
			"B":
				  bell.cmd = Cmd.BellB
		bellPos += 1
		$Camera.add_child(bell)
		bells.append(bell)
	currentLevel.clear()
	var y = 0
	for line in level.result.map:
		var x = 0
		var raw = {}
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
			raw[x] = addCmd(cmd, x, y)
			x += 1
		currentLevel[y] = raw
		y += 1
	execCommand()

func getCmd(x:int, y:int):
	if !currentLevel.has(y):
		return null
	var raw = currentLevel[y]
	if !raw.has(x):
		return null
	return raw[x]

func execCommand():
	var x = round($Car.translation.x)
	var y = round($Car.translation.z)
	var cmd = getCmd(x, y)
	var tmpCoord = $Car.getForwardRightCoord()
	var cmdForwardRight = getCmd(tmpCoord.x, tmpCoord.y)
	if cmd:
		cmd.exec($Car, cmdForwardRight)

func _on_Car_animation_ended():
	execCommand()

func getFirstSleepingBell():
	for bell in bells:
		if bell.isSleeping:
			return bell
	return null

func _on_CmdBell_bellRing(cmd):
	var sleepingBell = getFirstSleepingBell()
	if cmd == sleepingBell.cmd:
		sleepingBell.wakeUp()
	else:
		gameOver()

func gameOver():
	print("game over")
	#todo
