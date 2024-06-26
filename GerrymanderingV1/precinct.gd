extends Node2D
signal click

var x = null
var y = null
var rx = null
var ry = null
var party = null
var in_dist = false
var tile_scale = 1

# Currently randomly assigns 0 (pink) or 1 (yellow), with equal odds
func _ready():
	var parties = $AnimatedSprite2D.sprite_frames.get_animation_names()
	if Globals.level == 0:
		party = randi() % parties.size()
	else:
		party = Globals.level1_precincts[Globals.precinct_counter]
		Globals.precinct_counter += 1
	$AnimatedSprite2D.play(parties[party])

# For testing purposes: returns string "(x,y)"
func str_rxy():
	return '(' + str(rx) + ',' + str(ry) + ')'

func set_xy(x_pos,y_pos):
	x = x_pos
	y = y_pos

func get_x():
	return x
	
func get_y():
	return y

func set_rxy(x_pos,y_pos):
	rx = x_pos
	ry = y_pos

func get_rx():
	return rx
	
func get_ry():
	return ry

func set_party(p):
	party = p

func get_party():
	return party
	
func set_in_dist(boo):
	in_dist = boo
	
func get_in_dist():
	return in_dist

func _on_button_pressed():
	emit_signal('click')
	
func delete():
	queue_free()
	
func set_tile_scale(s):
	tile_scale = s
	
func get_tile_scale():
	return tile_scale
