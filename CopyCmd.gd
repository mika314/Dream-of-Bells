class_name CopyCmd

var cmd
# warning-ignore:unused_class_variable
var readOnly: bool

func _init(aCmd, aReadOnly: bool):
	cmd = aCmd
	readOnly = aReadOnly
