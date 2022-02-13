extends Node2D

var Effects = null
onready var Bullet_Blue = load("res://Weapons/Bullet_Blue.tscn")

var ready = true

func _ready():
	pass

func shoot(rot, pos):
	if ready:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var bullet = Bullet_Blue.instance()
			bullet.global_position = pos
			bullet.rotation = rot
			Effects.add_child(bullet)
			bullet = Bullet_Blue.instance()
			bullet.global_position = pos + Vector2(5,0).rotated(rot)
			bullet.rotation = rot + PI/8
			Effects.add_child(bullet)
			bullet = Bullet_Blue.instance()
			bullet.global_position = pos - Vector2(-5,0).rotated(rot)
			bullet.rotation = rot - PI/8
			Effects.add_child(bullet)
		ready = false
		$Timer.start()

func _on_Timer_timeout():
	ready = true
