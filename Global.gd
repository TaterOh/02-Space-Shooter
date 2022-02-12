extends Node

var View_Port = Vector2.ZERO
var VP = Vector2.ZERO
var score = 0
var time = 0
var lives = 5

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()
	View_Port = get_viewport().size
	VP = Vector2(1918,1080)
	var _signal = get_tree().get_root().connect("size_changed", self, "_resize")

func _resize():
	View_Port = get_viewport().size

func reset():
	get_tree().paused = false
	score = 0
	time = 0
	lives = 5

func update_score(s):
	score += s
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()

func update_lives(l):
	lives += l
	if lives <= 0:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_lives()

func update_time(t):
	time += t
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_time()
