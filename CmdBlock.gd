class_name CmdBlock
extends MeshInstance

#warning-ignore:unused_class_variable
export var cmd = Cmd.Empty
# warning-ignore:unused_class_variable
var readOnly: bool = false

signal hover
signal addCmdBlockTo
signal removeCmdBlockFrom

func hover(value):
	if !value || (value && !readOnly):
		emit_signal("hover", self, value)

func left_click():
	if !readOnly:
		emit_signal("addCmdBlockTo", self)

func right_click():
	if !readOnly:
		emit_signal("removeCmdBlockFrom", self)
