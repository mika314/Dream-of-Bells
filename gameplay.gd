extends Spatial

var levels = [
"""
{
  "map": [
      "  G ]C]",
      "]>S<{ -",
      "       ",
      "    ] ]",
  ],
  "cmds": "CEE",
  "bells": "CECEG"
}
""",
"""
{
  "map": [
    "]S<+ >+ >+ >+ > ]",
    "] >C-> -> -> -> ]"
  ],
  "cmds": "GFE",
  "bells": "GFEDCCDEFG"
}
""",
]

enum GameMode { Edit, Play }

var gameMode = GameMode.Edit

func addCmd(cmd, readOnly: bool, x: int, y: int):
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
	cmdBlock.readOnly = readOnly
	cmdBlock.translation.x = x
	cmdBlock.translation.y = 0
	cmdBlock.translation.z = y
	cmdBlock.cmd = cmd
	cmdBlock.connect("hover", self, "_on_CmdBlock_hover")
	cmdBlock.connect("addCmdBlockTo", self, "_on_CmdBlock_addCmdBlockTo")
	cmdBlock.connect("removeCmdBlockFrom", self, "_on_CmdBlock_removeCmdBlockFrom")
	add_child(cmdBlock)
	if !currentLevel.has(y):
		currentLevel[y] = {}
	if currentLevel[y].has(x):
		currentLevel[y][x].queue_free()
	currentLevel[y][x] = cmdBlock

var currentLevel = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	var level = JSON.parse(levels[0])
	if level.error != OK:
		print("JSON parese error ", level.error_string)
		return
	for bellColor in level.result.bells:
		$Camera/HUD.addBell(bellColor)
	for c in level.result.cmds:
		$Camera/HUD.addCmd(Cmd.charToCmd(c))
	currentLevel.clear()
	var y = 0
	for line in level.result.map:
		var x = 0
		for c in line:
			var cmd
			if c == "S":
				cmd = Cmd.Empty
				$Car.translation.x = x
				$Car.translation.z = y
			else:
				cmd = Cmd.charToCmd(c)
			addCmd(cmd, cmd != Cmd.Empty, x, y)
			x += 1
		y += 1

func getCmd(x: int, y: int):
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
		var roof = $Car.roof
		var res = cmd.exec($Car, cmdForwardRight)
		if cmd.cmd == Cmd.Put:
			addCmd(roof, false, tmpCoord.x, tmpCoord.y)
		elif cmd.cmd == Cmd.LeftIf || cmd.cmd == Cmd.RightIf:
			if res:
				$Eq.translation.x = tmpCoord.x
				$Eq.translation.z = tmpCoord.y
				$Eq/AnimationPlayer.play("Flash")
			else:
				$Neq.translation.x = tmpCoord.x
				$Neq.translation.z = tmpCoord.y
				$Neq/AnimationPlayer.play("Flash")

func _on_Car_animation_ended():
	if gameMode == GameMode.Play:
		execCommand()

func _on_CmdBell_bellRing(cmd):
	var sleepingBell = $Camera/HUD.getFirstSleepingBell()
	if sleepingBell && cmd == sleepingBell.cmd:
		sleepingBell.wakeUp()
	else:
		gameOver()

func gameOver():
	print("game over")
	#todo

# warning-ignore:unused_argument
func _process(delta):
	pass

func _on_CmdBlock_hover(cmdBlock, value):
	if value:
		$"cmd selected".translation = cmdBlock.translation
		$"cmd selected".visible = true
	else:
		$"cmd selected".visible = false

func _on_CmdBlock_addCmdBlockTo(cmdBlock):
	if cmdBlock.cmd != Cmd.Empty:
		$Camera/HUD.addCmd(cmdBlock.cmd)
	addCmd($Camera/HUD.getCurrentCmd(), false, cmdBlock.translation.x, cmdBlock.translation.z)
	$Camera/HUD.removeCurrentCmd()

func _on_CmdBlock_removeCmdBlockFrom(cmdBlock):
	if cmdBlock.cmd != Cmd.Empty:
		$Camera/HUD.addCmd(cmdBlock.cmd)
	addCmd(Cmd.Empty, false, cmdBlock.translation.x, cmdBlock.translation.z)

func _on_PlayButton_play():
	gameMode = GameMode.Play
	execCommand()


func _on_StopButton_stop():
	pass
