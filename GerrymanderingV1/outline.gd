extends Node2D

var tile_relatives = []
var direction = null

func set_direction(d):
	direction = d
	if direction == 'horiz':
		rotate(-PI/2)
		

func set_tile_relatives(tx,ty,pos):
	if pos == 'top':
		tile_relatives.append([tx,ty,'top'])
		tile_relatives.append([tx,ty-1,'bot'])
	elif pos == 'bot':
		tile_relatives.append([tx,ty+1,'top'])
		tile_relatives.append([tx,ty,'bot'])
	elif pos == 'left':
		tile_relatives.append([tx,ty,'left'])
		tile_relatives.append([tx-1,ty,'right'])
	else:
		tile_relatives.append([tx+1,ty,'left'])
		tile_relatives.append([tx,ty,'right'])

func get_tile_relatives():
	return tile_relatives

func delete():
	queue_free()
