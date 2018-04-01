extends Area2D

signal hit

var multiplier = 1

var direction = Vector2()
var speed = 1000
var cost = 20 
var power = 50 


func _ready():
	$AudioStreamPlayer2D.stream = load("res://sound/magic_throw.wav")
	$AudioStreamPlayer2D.play()
	cost *= multiplier
	power *= multiplier
	if scale * multiplier < Vector2(10,10):
		scale *= multiplier

func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fire1_body_entered( body ):
	if body == get_parent():
		yield()
	emit_signal("hit")
	set_process(false)
	if body is KinematicBody2D:
		body.hit(power)
	$AudioStreamPlayer2D.stream = load("res://sound/explosion.wav")
	$AudioStreamPlayer2D.play()
	Input.start_joy_vibration(0,1,0,.5)
	$CollisionShape2D.queue_free()
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
