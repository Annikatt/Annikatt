extends Node2D

@onready var tile = preload("res://precinct.tscn")
@onready var grid = get_node("grid")
@onready var district = preload("res://district.tscn")
@onready var districts = get_node("districts")
@onready var outline = preload("res://outline.tscn")
@onready var outlines = get_node("outlines")
@onready var finalize_button = get_node("finalize_button")
var current_selection = null
var districts_used = []

# Returns the first available unused district.
func get_next_district():
	var i = 0
	for used in districts_used:
		if not used:
			return get_district(i)
		i += 1
	return null

# Given relative x and y values, returns a precinct
func get_precinct(rx,ry):
	for child in grid.get_children():
		if child.rx == rx and child.ry == ry:
			return child
	return null

# Returns true if precinct t is in district dist, or false otherwise
func tile_in_district(t,dist):
	for dist_tile in dist.get_tiles():
		if dist_tile == t:
			return true
	return false

# Returns true if tile t is adjacent to district dist, or false otherwise
func adjacent_to_district(t,dist):
	for dist_tile in dist.get_tiles():
		if adjacent(t,dist_tile):
			return true
	return false

# Assumes t1 and t2 are adjacent
# Returns 'top', 'left', 'right', or 'bot', indicating the position of t1 relative to t2
func shared_side(t1,t2):
	if t1.get_ry() == (t2.get_ry() - 1):
		return 'top'
	elif t1.get_rx() == (t2.get_rx() - 1):
		return 'left'
	elif t1.get_rx() == (t2.get_rx() + 1):
		return 'right'
	else:
		return 'bot'

# Returns a list of 4 booleans, representing top, left, right, and bottom respectively
# Will be true if there is a tile in dist that is adjacent to t in that direction, or false otherwise
func adjacencies(t,dist):
	var sides = [false,false,false,false]
	for dist_tile in dist.get_tiles():
		if adjacent(dist_tile,t):
			if shared_side(dist_tile,t) == 'top':
				sides[0] = true
			elif shared_side(dist_tile,t) == 'left':
				sides[1] = true
			elif shared_side(dist_tile,t) == 'right':
				sides[2] = true
			else:
				sides[3] = true
	return sides
	
# Given relative x and y values and a position, 'top' ,'left', 'right', or 'bot',
# returns the outline segment at that location.
func get_outline(rx,ry,pos):
	for child in outlines.get_children():
		if [rx,ry,pos] in child.get_tile_relatives():
			return child
	return null

# Returns a district based on its ID number 'num'
func get_district(n):
	for child in districts.get_children():
		if child.get_num() == n:
			return child
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_grid(5,5,300,300,0,0)
	generate_districts(5)
	finalize_button.pressed.connect(_finalize.bind())

func _finalize():
	get_tree().change_scene_to_file('res://end_page.tscn')
	
# Creates a rectangle of precincts with width and height
# x and y are global positions
# rx and ry are the precincts' relative positions
func generate_grid(width,height,start_x,start_y,start_rx,start_ry):
	var x = start_x
	var y = start_y
	var rx = start_rx
	var ry = start_ry
	for i in range(width):
		for j in range(height):
			var tile_to_add = tile.instantiate()
			grid.add_child(tile_to_add)
			tile_to_add.set_xy(x,y)
			tile_to_add.set_rxy(rx,ry)
			tile_to_add.position = Vector2(x, y)
			y += 110
			ry += 1
		y = start_y
		ry = start_ry
		x += 110
		rx += 1	
	for t in grid.get_children():
		t.click.connect(_tile_clicked.bind(t))
		
#  Generates n district containers
func generate_districts(n):
	for dis in range (n):
		var district_to_add = district.instantiate()
		district_to_add.set_num(dis)
		districts.add_child(district_to_add)
		districts_used.append(false)	
	
# Returns true if tile1 and tile2 are adjacent, or false if not
func adjacent(tile1,tile2):
	if abs(tile1.get_rx() - tile2.get_rx()) == 1 and tile1.get_ry() == tile2.get_ry():
		return true
	elif abs(tile1.get_ry() - tile2.get_ry()) == 1 and tile1.get_rx() == tile2.get_rx():
		return true
	else:
		return false

# Given a precinct t, returns the district that t is a part of,
# or null if t is not in any district		
func _get_district_from_precinct(t):
	for child in districts.get_children():
			if tile_in_district(t,child):
				return child
	return null			

# Adds outlines to a tile on sides for which true is passed
func _outline_tile(t,top=true,left=true,right=true,bot=true):
	if top:
		var new_outline = outline.instantiate()
		outlines.add_child(new_outline)
		new_outline.set_direction('horiz')
		new_outline.position = Vector2(t.get_x() - 10, t.get_y())
		new_outline.set_tile_relatives(t.get_rx(),t.get_ry(),'top')
	if left:
		var new_outline = outline.instantiate()
		outlines.add_child(new_outline)
		new_outline.set_direction('vert')
		new_outline.position = Vector2(t.get_x() - 10, t.get_y() - 10)
		new_outline.set_tile_relatives(t.get_rx(),t.get_ry(),'left')
	if right:
		var new_outline = outline.instantiate()
		outlines.add_child(new_outline)
		new_outline.set_direction('vert')
		new_outline.position = Vector2(t.get_x() + 100, t.get_y() - 10)
		new_outline.set_tile_relatives(t.get_rx(),t.get_ry(),'right')
	if bot:
		var new_outline = outline.instantiate()
		outlines.add_child(new_outline)
		new_outline.set_direction('horiz')
		new_outline.position = Vector2(t.get_x() - 10, t.get_y() + 110)
		new_outline.set_tile_relatives(t.get_rx(),t.get_ry(),'bot')

# Removes outlines from a tile on sides for which true is passed
func _remove_outline_tile(t,top,left,right,bot):
	if top:
		if get_outline(t.get_rx(),t.get_ry(),'top') != null:
			get_outline(t.get_rx(),t.get_ry(),'top').delete()
	if left:
		if get_outline(t.get_rx(),t.get_ry(),'left') != null:
			get_outline(t.get_rx(),t.get_ry(),'left').delete()
	if right:
		if get_outline(t.get_rx(),t.get_ry(),'right') != null:
			get_outline(t.get_rx(),t.get_ry(),'right').delete()
	if bot:
		if get_outline(t.get_rx(),t.get_ry(),'bot') != null:
			get_outline(t.get_rx(),t.get_ry(),'bot').delete()

# Returns true iff district dist contains a number of children equal
# to target
func _check_size(dist,target):
	if len(dist.get_tiles()) == target:
		return true
	else:
		return false

# Returns true if dist is contiguous, or false otherwise
func _check_contiguous(dist):
	var total = len(dist.get_tiles())
	var checked = []
	var start = dist.get_tiles()[0]
	checked.append(start)
	for x in range(total):
		for t1 in dist.get_tiles():
			for t2 in checked:
				if t1 not in checked:
					if adjacent(t1,t2):
						checked.append(t1)
	if len(checked) == total:
		return true
	return false
					
# Checks to make sure that every tile is in a district and
# every district has between min_size and max_size tiles in it
# then enables the finalize button if all checks are passed
func _check_all(min_size, max_size):
	for t in grid.get_children():
		if t.get_in_dist() == false:
			finalize_button.disable()
			return
	for dist in districts.get_children():
		if (_check_size(dist,min_size) == false) and (_check_size(dist,max_size) == false):
			finalize_button.disable()
			return
		if _check_contiguous(dist) == false:
			finalize_button.disable()
			return
	finalize_button.enable()
	
# Stuff happens on tile clicked
func _tile_clicked(t):
	if current_selection == null:
		current_selection = _get_district_from_precinct(t)
		if current_selection == null:
			if get_next_district() != null:
				current_selection = get_next_district()
				districts_used[current_selection.get_num()] = true
				current_selection.add_tile(t)
				t.set_in_dist(true)
				_outline_tile(t)
	else:
		if tile_in_district(t,current_selection):
			current_selection.remove_tile(t)
			t.set_in_dist(false)
			var to_keep = adjacencies(t,current_selection)
			_remove_outline_tile(t,not to_keep[0],not to_keep[1],not to_keep[2],not to_keep[3])
			_outline_tile(t,to_keep[0],to_keep[1],to_keep[2],to_keep[3])
			if current_selection.get_tiles() == []:
				districts_used[current_selection.get_num()] = false
		elif adjacent_to_district(t,current_selection) and _get_district_from_precinct(t)==null:
			current_selection.add_tile(t)
			t.set_in_dist(true)
			var adj = adjacencies(t,current_selection)
			_outline_tile(t,not adj[0],not adj[1],not adj[2],not adj[3])
			_remove_outline_tile(t,adj[0],adj[1],adj[2],adj[3])
		else:
			if _get_district_from_precinct(t) != null:
				current_selection = _get_district_from_precinct(t)
			elif get_next_district() != null:
				current_selection = get_next_district()
				districts_used[current_selection.get_num()] = true
				current_selection.add_tile(t)
				t.set_in_dist(true)
				_outline_tile(t)
	_check_all(5,5)
