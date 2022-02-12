extends Node2D

onready var Asteroid = load("res://Asteroid/Asteroid.tscn")
var positions = [Vector2(Global.VP.x, 0), Vector2(0, Global.VP.y)]

func _on_Timer_timeout():
	var asteroid = Asteroid.instance()
	asteroid.position = positions[randi() % positions.size()]
	add_child(asteroid)
