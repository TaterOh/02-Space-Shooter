extends Area2D

var velocity = Vector2(500,0)
var base_velocity = velocity
var damage = 4

var target = null
var Effects = null
var turning = deg2rad(3)
onready var Explosion = load("res://Effects/Explosion.tscn")

func _ready():
	velocity = velocity.rotated(rotation)
	target = find_target()
	

func _physics_process(delta):
	target = find_target()
	if target != null:
		var dir = wrapf(global_position.direction_to(target.global_position).angle(), -PI,PI)
		var rot = wrapf(rotation,-PI,PI)
		var amount = dir - rot
		if abs(amount) > PI:
			amount = PI
		amount = clamp(amount, -turning, turning)
		if amount != 0:
			rotation += amount
			velocity = base_velocity.rotated(rotation)
	position += velocity * delta
	position.x = wrapf(position.x, 0, Global.VP.x)
	position.y = wrapf(position.y, 0, Global.VP.y)

func find_target():
	var to_return = null
	var Enemies = get_node_or_null("/root/Game/Enemy_Container")
	var test_dist = 1000000000
	if Enemies != null:
		for e in Enemies.get_children():
			if "health" in e:
				var dist = global_position.distance_to(e.global_position)
				if dist < test_dist:
					to_return = e
					test_dist = dist
	return to_return


func _on_Timer_timeout():
	queue_free()


func _on_Missile_body_entered(body):
	if body.name != "Player" and body.has_method("damage"):
		body.damage(damage)
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var explosion = Explosion.instance()
		Effects.add_child(explosion)
		explosion.global_position = global_position
	queue_free()
