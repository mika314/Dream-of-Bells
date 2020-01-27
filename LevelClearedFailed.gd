extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	var n = global.selectedLevel
	var pos = $dig1.translation.x
	var delta = $dig1.translation.x - $dig0.translation.x
	for i in [1, 2]:
		var dig
		match n % 10:
			0: 
				dig = $dig0
			1: 
				dig = $dig1
			2: 
				dig = $dig2
			3: 
				dig = $dig3
			4: 
				dig = $dig4
			5: 
				dig = $dig5
			6: 
				dig = $dig6
			7: 
				dig = $dig7
			8: 
				dig = $dig8
			9: 
				dig = $dig9
		n /= 10
		var newMesh = dig.duplicate()
		newMesh.translation.x = pos
		newMesh.visible = true
		add_child(newMesh)
		pos -= delta

func levelCleared():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	$"Level Failed".visible = false
	$"Level Cleared".visible = true

func levelFailed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	$"Level Failed".visible = true
	$"Level Cleared".visible = false

signal levels
signal restart
signal next

func _on_Levels_click():
	emit_signal("levels")

func _on_Restart_click():
	emit_signal("restart")

func _on_Next_click():
	emit_signal("next")
