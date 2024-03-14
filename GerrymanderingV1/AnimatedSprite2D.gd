extends AnimatedSprite2D

var direction = null

func set_direction(d):
	if d == 1:
		direction = 1
		rotate(90)
	else:
		direction = 0
