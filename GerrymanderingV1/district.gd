extends Node2D

var num = null
var tiles = []


func set_num(n):
	num = n
	
func get_num():
	return num

func add_tile(t):
	tiles.append(t)
	
func remove_tile(t):
	var new_tiles = []
	for tile in tiles:
		if tile != t:
			new_tiles.append(tile)
	tiles = new_tiles

func get_tiles():
	return tiles
			
