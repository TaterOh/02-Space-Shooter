extends KinematicBody2D

var speed = 5
var health = 1
var turn_speed = 0.05
var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")

func damage(d):
	health -= d
	if health <= 0:
		Global.update_score(500)
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		queue_free()

func _physics_process(delta):
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	if Player != null:
		var d = lerp_angle(global_rotation, global_position.angle_to_point(Player.global_position) - PI/2, turn_speed)
		rotation = d
		position += Vector2(0,-speed).rotated(d)
	position.x = wrapf(position.x,0,Global.VP.x)
	position.y = wrapf(position.y,0,Global.VP.y)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)
