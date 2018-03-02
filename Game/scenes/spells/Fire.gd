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


func _on_Fire1_body_entered( body ):
	if body == get_parent():
		yield()
	set_process(false)
	if body is KinematicBody:
		body.hit(power)
	$particles/Sprite.hide()
	$particles.emitting = false
	$explode.emitting = true
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	queue_free()
