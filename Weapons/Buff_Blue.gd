extends Area2D

func _ready():
	pass

func _on_Buff_Red_body_entered(body):
	if body.name == "Player" and body.has_method("buff_blue"):
		body.buff_blue()
		queue_free()
