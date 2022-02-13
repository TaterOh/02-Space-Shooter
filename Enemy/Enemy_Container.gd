extends Node2D

var enemies = []
var positions = [Vector2(Global.VP.x, 0), Vector2(0, Global.VP.y)]

func _ready():
	enemies.append(load("res://Enemy/Enemy.tscn"))
	enemies.append(load("res://Enemy/Vacuum.tscn"))
	enemies.append(load("res://Enemy/Rocket.tscn"))

func _on_Timer_timeout():
	var enemy = enemies[randi() % enemies.size()].instance()
	enemy.position = positions[randi() % positions.size()]
	add_child(enemy)
