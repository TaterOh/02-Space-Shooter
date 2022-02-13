extends Node2D

var Effects = null
onready var Missile = load("res://Weapons/Missile.tscn")

var ready = true

func _ready():
	pass

func shoot(rot, pos):
	if ready:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var bullet = Missile.instance()
			bullet.global_position = pos
			bullet.rotation = rot - PI/2
			Effects.add_child(bullet)
		ready = false
		$Timer.start()

func _on_Timer_timeout():
	ready = true
