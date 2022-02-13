extends Node2D

var buffs = []

func _ready():
	buffs.append(load("res://Weapons/Buff_Red.tscn"))
	buffs.append(load("res://Weapons/Buff_Blue.tscn"))

func _physics_process(_delta):
	if get_child_count() == 0:
		var buff = buffs[randi() % buffs.size()].instance()
		buff.position = Vector2(randf()*Global.VP.x, randf()*Global.VP.y)
		add_child(buff)
