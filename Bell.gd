extends MeshInstance

var eyesOpen
var eyesClosed

func _ready():
	eyesOpen = $"Eyes Open"
	eyesClosed = $"Eyes Closed"
	eyesOpen.visible = false
	eyesClosed.visible = true
	$TimerClose.start()

func _on_TimerClose_timeout():
	eyesOpen.visible = false
	eyesClosed.visible = true
	$TimerOpen.start()

func _on_TimerOpen_timeout():
	eyesOpen.visible = !isSleeping
	eyesClosed.visible = isSleeping

var isSleeping = true

# warning-ignore:unused_class_variable
var cmd = Cmd.Empty

func wakeUp():
	isSleeping = false;
	eyesOpen.visible = !isSleeping
	eyesClosed.visible = isSleeping
