extends Node2D

var Effects = null
onready var Bullet_Red = load("res://Weapons/Bullet_Red.tscn")

var ready = true

func _ready():
	pass

func shoot(rot, pos):
	if ready:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var bullet = Bullet_Red.instance()
			bullet.global_position = pos
			bullet.rotation = rot
			Effects.add_child(bullet)
		ready = false
		$Timer.start()

func _on_Timer_timeout():
	ready = true
