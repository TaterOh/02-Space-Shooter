extends KinematicBody2D

var mass = 55000
var health = 2
var initial_speed = 100.0
var move = Vector2(10,10)
var push_force = 1000

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")

func _ready():
	move = Vector2(0,initial_speed*randf()).rotated(PI*2*randf())

func _physics_process(delta):
	position += move * delta
	position.x = wrapf(position.x, 0, Global.VP.x)
	position.y = wrapf(position.y, 0, Global.VP.y)
	var bodies = $Gravity.get_overlapping_bodies()
	for body in bodies:
		if "velocity" in body:
			var gravity = global_position.direction_to(body.global_position) * 1/pow(global_position.distance_to(body.global_position),2) * mass
			body.velocity -= gravity

func damage(d):
	health -= d
	if health <= 0:
		Global.update_score(300)
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)
	elif "velocity" in body:
		var push = global_position.direction_to(body.global_position) * push_force
		body.velocity += push
