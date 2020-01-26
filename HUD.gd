extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateCmdPos():
	var pos = 0
	for cmd in cmds:
		cmd.translation = $Cmd.translation + Vector3((pos - currentCmd) * 0.25, 0, 0)
		pos += 1

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_next_cmd"):
		if currentCmd < cmds.size() - 1:
			currentCmd += 1
			updateCmdPos()
	if Input.is_action_just_pressed("ui_prev_cmd"):
		if currentCmd > 0:
			currentCmd -= 1
			updateCmdPos()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_DOWN:
				if currentCmd < cmds.size() - 1:
					currentCmd += 1
					updateCmdPos()
			if event.button_index == BUTTON_WHEEL_UP:
				if currentCmd > 0:
					currentCmd -= 1
					updateCmdPos()

var bells = []
var cmds = []
var currentCmd = 0

func addBell(bellColor):
	var bell = $Bell.duplicate()
	bell.mesh = load("res://bell " + bellColor + ".mesh")
	bell.visible = true
	bell.translate(Vector3(0, 0, -bells.size()))
	bell.cmd = Cmd.charToCmd(bellColor)
	add_child(bell)
	bells.append(bell)

func loadCmdMesh(cmd):
	match cmd:
		Cmd.Empty:
			return load("res://cmd 00 empty.mesh")
		Cmd.Right:
			return load("res://cmd 01 right.mesh")
		Cmd.Left:
			return load("res://cmd 02 left.mesh")
		Cmd.RightIf:
			return load("res://cmd 03 right if.mesh")
		Cmd.LeftIf:
			return load("res://cmd 04 left if.mesh")
		Cmd.Take:
			return load("res://cmd 05 take.mesh")
		Cmd.Put:
			return load("res://cmd 06 put.mesh")
		Cmd.Inc:
			return load("res://cmd 07 inc.mesh")
		Cmd.Dec:
			return load("res://cmd 08 dec.mesh")
		Cmd.BellC:
			return load("res://cmd 09 bell C.mesh")
		Cmd.BellD:
			return load("res://cmd 10 bell D.mesh")
		Cmd.BellE:
			return load("res://cmd 11 bell E.mesh")
		Cmd.BellF:
			return load("res://cmd 12 bell F.mesh")
		Cmd.BellG:
			return load("res://cmd 13 bell G.mesh")
		Cmd.BellA:
			return load("res://cmd 14 bell A.mesh")
		Cmd.BellB:
			return load("res://cmd 15 bell B.mesh")
		_:
			return load("res://cmd 00 empty.mesh")

func addCmd(c):
	var cmd = $Cmd.duplicate()
	cmd.mesh = loadCmdMesh(c)
	cmd.visible = true
	cmd.translation = $Cmd.translation + Vector3(cmds.size() * 0.25 - currentCmd, 0, 0)
	cmd.cmd = c
	add_child(cmd)
	cmds.append(cmd)

func getFirstSleepingBell():
	for bell in bells:
		if bell.isSleeping:
			return bell
	return null

func getCurrentCmd():
	if currentCmd >= cmds.size() || currentCmd < 0:
		return Cmd.Empty
	return cmds[currentCmd].cmd

func removeCurrentCmd():
	if currentCmd >= cmds.size() || currentCmd < 0:
		return
	cmds[currentCmd].queue_free()
	cmds.remove(currentCmd)
	if currentCmd >= cmds.size():
		currentCmd = cmds.size() - 1
	if currentCmd < 0:
		currentCmd = 0
	updateCmdPos()
