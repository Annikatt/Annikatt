extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true

func disable():
	disabled = true

func enable():
	disabled = false
	
func _on_pressed():
	pass
	
