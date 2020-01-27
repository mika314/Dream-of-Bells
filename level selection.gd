extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Level_hover(level, value: bool):
	$Selection.visible = value
	if value:
		$Selection.translation = level.translation


func _on_Level_click(level):
	global.selectedLevel = level.levelNum
	get_tree().change_scene("res://gameplay.tscn")
