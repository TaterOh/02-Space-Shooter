extends KinematicBody2D

var velocity = Vector2.ZERO

var rotation_speed = 5.0
var speed = 10.0
var max_speed = 400.0

var health = 1
var shields = 0
var shield_regen = 0.5
var shield_max = 5.0
var is_shielding = false
var shield_textures = [
	preload("res://Effects/shield1.png"),
	preload("res://Effects/shield2.png"),
	preload("res://Effects/shield3.png")
]

var buffs = 0

var friction = 0.015
var invincible = false

var Effects = null
onready var Explosion = load("res://Effects/Explosion.tscn")

var nose = Vector2(0,-64)

func _physics_process(delta):
	velocity = velocity + get_input()*speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	velocity -= velocity * friction
	velocity = move_and_slide(velocity, Vector2.ZERO)
	position.x = wrapf(position.x, 0, Global.VP.x)
	position.y = wrapf(position.y, 0, Global.VP.y)
	shields = clamp(shield_regen*delta + shields, -10, shield_max)

func shoot():
	for w in $Primary.get_children():
		if w.has_method("shoot"):
			w.shoot(rotation, global_position + nose.rotated(rotation))

func shoot_secondary():
	for w in $Secondary.get_children():
		if w.has_method("shoot"):
			w.shoot(rotation, global_position + nose.rotated(rotation))

func buff_red():
	for w in $Primary.get_children():
		w.queue_free()
	var weapon = load("res://Weapons/PewPew.tscn")
	$Primary.add_child(weapon.instance())

func buff_blue():
	for w in $Primary.get_children():
		w.queue_free()
	var weapon = load("res://Weapons/Shotgun.tscn")
	$Primary.add_child(weapon.instance())

func shield():
	if shields >= shield_max * 0.66:
		$Shield.show()
		$Shield/Sprite.texture = shield_textures[2]
	elif shields >= shield_max * 0.33:
		$Shield.show()
		$Shield/Sprite.texture = shield_textures[1]
	elif shields >= 0:
		$Shield.show()
		$Shield/Sprite.texture = shield_textures[0]
	else:
		$Shield.hide()

func get_input():
	var to_return = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("forward"):
		to_return.y -= 1
		$Exhaust.show()
	if Input.is_action_pressed("left"):
		rotation_degrees = rotation_degrees - rotation_speed
	if Input.is_action_pressed("right"):
		rotation_degrees = rotation_degrees + rotation_speed
	if Input.is_action_pressed("shield"):
		is_shielding = true
		shield()
	else:
		is_shielding = false
		$Shield.hide()
	if Input.is_action_pressed("shoot") and not is_shielding:
		shoot()
	elif Input.is_action_pressed("shoot_secondary") and not is_shielding:
		shoot_secondary()
	return to_return.rotated(rotation)

func damage(d):
	if not invincible:
		health -= d
	if health <= 0:
		if not invincible:
			Global.update_lives(-1)
		invincible = true
		$Invin_Timer.start()
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
			hide()
			yield(explosion, "animation_finished")
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name != "Player":
		damage(100)

func _on_Invin_Timer_timeout():
	invincible = false

func _on_Shield_body_entered(body):
	if is_shielding and body != self and body.has_method("damage") and shields > 0:
		shields -= 5
		body.damage(100)

func _on_Shield_area_entered(area):
	if is_shielding and "damage" in area.get_parent() and shields > 0:
		shields -= area.get_parent().damage
		area.get_parent().queue_free()
