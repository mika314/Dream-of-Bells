extends MeshInstance

var eyesOpen
var eyesClosed

func _ready():
	eyesOpen = $"Eyes Open"
	eyesClosed = $"Eyes Closed"
	$TimerClose.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TimerClose_timeout():
	eyesOpen.visible = false
	eyesClosed.visible = true
	$TimerOpen.start()

func _on_TimerOpen_timeout():
	eyesOpen.visible = true
	eyesClosed.visible = false
