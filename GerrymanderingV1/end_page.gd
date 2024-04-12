extends Node2D

@onready var level = preload("res://main_level.gd")
@onready var textbox = get_node('RichTextLabel')
var results = Globals.level1_results

# Called when the node enters the scene tree for the first time.
func _ready():
	if results[0] > results[1]:
		set_text('pink wins!: '+str(results))
	elif results[0] < results[1]:
		set_text('yellow wins! '+str(results))
	else:
		set_text('tie!')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_text(message):
	textbox.text = str(message)
