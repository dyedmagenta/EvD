extends Node

signal next_level
signal spawn_dwarf
signal spawn_boss

export(int) var dwarves_per_level : int = 10

var current_level : int  = 1

var killed_dwarves : int = 0

onready var dwarves_spawner = get_parent().get_node("DwarvesSpawner") 

var level_label
var killed_dwarves_label

func _ready():
	var ui = get_parent().get_node("UI")
	level_label = ui.find_node("LevelLabel")
	killed_dwarves_label = ui.find_node("KilledDwarvesLabel")
	
	set_level_label()
	set_killed_dwarves_label()
	
	self.connect("next_level", dwarves_spawner, "on_next_level")
	
func increase_level():
	killed_dwarves = 0
	current_level += 1
	set_level_label()
	emit_signal("next_level", current_level)
	
func on_Dwarf_died():
	killed_dwarves += 1
	
	if killed_dwarves >= dwarves_per_level:
		if current_level % 10 == 0:
			# Spawn boss
			print('The Boss is coming...')
			emit_signal("spawn_boss")
		else:
			emit_signal("spawn_dwarf")
			increase_level()
	else:
		emit_signal("spawn_dwarf")
	
	set_killed_dwarves_label()
	
func on_Boss_died():
	increase_level()
	emit_signal("spawn_dwarf")
	set_killed_dwarves_label()

func set_killed_dwarves_label():
	killed_dwarves_label.text = str(killed_dwarves, " / ", dwarves_per_level)

func set_level_label():
	level_label.text = str("Poziom ", current_level)