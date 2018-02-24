extends Area2D

signal hit

var multiplier = 1

var direction = Vector2()
var speed = 1000
var cost = 10 * multiplier
var power = 50 * multiplier


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
