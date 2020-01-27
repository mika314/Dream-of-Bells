extends Spatial

var levels = [
# 1
"""
  {
    "map": [
      "   C",
      "   D",
      "S C "
    ],
    "cmds": "[DC",
    "bells": "CDC"
  }
""",
# 2
"""
  {
    "map": [
      "  C",
      "S  "
    ],
    "cmds": "[]",
    "bells": "C"
  }
""",
# 3
"""
    {
      "map": [
        "   ",
        "  C",
        "S  ",
      ],
      "cmds": "[D]",
      "bells": "CD"
    }
""",
# 4
"""
    {
      "map": [
        "      ",
        "  C E ",
        "S     ",
      ],
      "cmds": "[D]]",
      "bells": "CED"
    }
""",
# 5
"""
    {
      "map": [
        "S    ]",
        "   C ]",
      ],
      "cmds": "<>",
      "bells": "CC"
    }
""",
# 6
"""
    {
      "map": [
        "S    ]",
        "  DE ]",
      ],
      "cmds": "<>-",
      "bells": "CED"
    }
""",
# 7
"""
    {
      "map": [
        "]S ]",
        "D CD",
        "]  ]",
      ],
      "cmds": "}<",
      "bells": "DDC"
    }
""",
# 8
"""
    {
      "map": [
        "  ] ]",
        "S<   ",
        "  C  ",
        "  ]>]",
      ],
      "cmds": "+{C",
      "bells": "DEFGAB"
    }
""",
# 9
"""
    {
      "map": [
        "]>]  ",
        "S C  ",
        "] +<]",
        " ] F ",
        "] ]  ",
      ],
      "cmds": "[]>]",
      "bells": "CDEF"
    }
""",
# 10
"""
    {
      "map": [
        "  C      ",
        "[       [",
        "-] S<CDE[",
        " ] C[    ",
        "         ",
        "[   [    ",
      ],
      "cmds": "[>]{E>",
      "bells": "CDECCDECC"
    }
""",
# 11
"""
    {
      "map": [
        "        ",
        "SCDEFG{]",
      ],
      "cmds": "]]CDE",
      "bells": "CDEFGGFEDC"
    }
""",
# 12
"""
    {
      "map": [
        "S<+ >+ >+ >+ > ]",
        " >C-> -> -> ->  ",
      ],
      "cmds": "]]]GFE",
      "bells": "GFEDCCDEFG"
    }
""",
# 13
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
var copyLevel = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loadLevel(global.selectedLevel)

func loadLevel(l: int):
	$LevelStr.text = "Level " + str(l)
	var level = JSON.parse(levels[l - 1])
	if level.error != OK:
		print("JSON parese error ", level.error_string)
		return
	for bellColor in level.result.bells:
		$Camera/HUD.addBell(bellColor)
	for c in level.result.cmds:
		$Camera/HUD.addCmd(Cmd.charToCmd(c))
	currentLevel.clear()
	var R = 25
	for y in range(-R, R):
		for x in range(-sqrt(R * R - y * y), sqrt(R * R - y * y)):
			addCmd(Cmd.Empty, false, x, y)
	var y = 0
	for line in level.result.map:
		var x = 0
		for c in line:
			var cmd
			if c == "S":
				cmd = Cmd.Empty
				$Car.setInitPos(x, y)
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
	else:
		$Car.reset()

func _on_CmdBell_bellRing(cmd):
	var sleepingBell = $Camera/HUD.getFirstSleepingBell()
	if sleepingBell && cmd == sleepingBell.cmd:
		sleepingBell.wakeUp()
		if $Camera/HUD.sleepingBellsNum() == 0:
			$Camera/HUD.levelCleared()
	else:
		$Camera/HUD.levelFailed()

func levelFailed():
	print("levelFailed")
	#todo

func levelCleared():
	print("levelPassed")

# warning-ignore:unused_argument
func _process(delta):
	pass

func _on_CmdBlock_hover(cmdBlock, value):
	$"cmd selected".translation = cmdBlock.translation
	$"cmd selected".visible = value && gameMode == GameMode.Edit

func _on_CmdBlock_addCmdBlockTo(cmdBlock):
	if gameMode != GameMode.Edit:
		return
	if cmdBlock.cmd != Cmd.Empty:
		$Camera/HUD.addCmd(cmdBlock.cmd)
	addCmd($Camera/HUD.getCurrentCmd(), false, cmdBlock.translation.x, cmdBlock.translation.z)
	$Camera/HUD.removeCurrentCmd()

func _on_CmdBlock_removeCmdBlockFrom(cmdBlock):
	if gameMode != GameMode.Edit:
		return
	if cmdBlock.cmd != Cmd.Empty:
		$Camera/HUD.addCmd(cmdBlock.cmd)
	addCmd(Cmd.Empty, false, cmdBlock.translation.x, cmdBlock.translation.z)

func _on_PlayButton_play():
	if gameMode == GameMode.Play:
		return
# warning-ignore:return_value_discarded
	gameMode = GameMode.Play
	copyLevel.clear()
	for y in currentLevel:
		copyLevel[y] = {}
		for x in currentLevel[y]:
			var tmp = currentLevel[y][x]
			copyLevel[y][x] = CopyCmd.new(tmp.cmd, tmp.readOnly)
	execCommand()
	
func restart():
	if gameMode == GameMode.Edit:
		return
	gameMode = GameMode.Edit
	for y in copyLevel:
		for x in copyLevel[y]:
			var tmp = copyLevel[y][x]
			addCmd(tmp.cmd, tmp.readOnly, x, y)
	$Car.reset()
	$Camera/HUD.reset()

func _on_StopButton_stop():
	restart()
	
func switchToLevelSelectionScreen():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://level selection.tscn")

func _on_LevelsButton_levels():
	switchToLevelSelectionScreen()

func _on_LevelClearedFailed_levels():
	switchToLevelSelectionScreen()

func _on_LevelClearedFailed_next():
	global.selectedLevel += 1
	get_tree().change_scene("res://gameplay.tscn")


func _on_LevelClearedFailed_restart():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera/HUD/LevelClearedFailed.visible = false
	restart()
