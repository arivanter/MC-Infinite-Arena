extends KinematicBody2D

# enemy parameters 

onready var player = get_parent().get_node("player")
onready var hp_anim = get_node("Health/AnimationPlayer")
onready var anim = $AnimationPlayer
var multiplier = 1.0
var power = 2
var max_health = 100.0
var health
var atk_timer = null
var can_move
var move_dir_rand
var WALK_SPEED = 200.0
var FOLLOW_SPEED = 300.0
var velocity = Vector2()
var timer = null
var walk_delay = 2
var following_player = false
var rand_move = true
var attacking = false
signal dead






func _ready():
	$Particles2D.emitting = false
	can_move = true
	rand_move = true
	max_health *= multiplier
	health = max_health
	$Health.max_value = max_health
	$Health.value = health
	power *= multiplier
	WALK_SPEED *= multiplier
	FOLLOW_SPEED *= multiplier
	
	# walk timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.wait_time = walk_delay
	timer.connect("timeout", self, "on_timer_complete")
	add_child(timer)
	
	atk_timer = Timer.new()
	atk_timer.set_one_shot(true)
	atk_timer.wait_time = .1
	atk_timer.connect("timeout", self, "attack")
	add_child(atk_timer)
	
	select_random_dir()



func _physics_process(delta):
	
	$Health.value = health
	
	if $Particles2D.emitting == true:
		$AudioStreamPlayer2D.play()
		
	if !rand_move:
		velocity = player.position - position
		velocity = velocity.normalized() * FOLLOW_SPEED * (-1)
	if can_move:
		move_and_slide(velocity, Vector2(0,0))
		if velocity == Vector2(0,0):
			if anim.current_animation != "":
				anim.seek(0.0,true)
		else:
			animate()
	if timer.is_stopped():
		timer.start()
			
			
		# reset step to idle after finishing walk
#		elif current_state == WALK and move_dir_rand == 0:
#			
	
	
	
##################
#### movement ####

func on_timer_complete():
	if not following_player:
		select_random_dir()



func select_random_dir():
	move_dir_rand = randi()%5
	if move_dir_rand == 1:
		velocity.x = - WALK_SPEED
		velocity.y = 0
		
	elif move_dir_rand == 2:
		velocity.x =   WALK_SPEED
		velocity.y = 0
		
	elif move_dir_rand == 3:
		velocity.y = - WALK_SPEED
		velocity.x = 0
		
	elif move_dir_rand == 4:
		velocity.y =   WALK_SPEED
		velocity.x = 0
	else:
		velocity = Vector2(0,0)



################
#### attack ####

func attack():
	player.hit(power)
	$Particles2D.emitting = true
	atk_timer.start()
	
	
func _on_TraceArea_body_entered(body):
	if body == player:
		following_player = true



func _on_TraceArea_body_exited(body):
	if body == player:
		following_player = false
		
		
	
func _on_AttackArea_body_entered( body ):
	if body == player:
		attacking = true
		rand_move = false
		attack()

func _on_AttackArea_body_exited( body ):
	rand_move = true
	attacking = false
	$Particles2D.emitting = false
	atk_timer.stop()
	
	
###########################
#### health management ####

func hit(damage):
	if hp_anim.current_animation != "fade":
		hp_anim.play("fade")
	if can_move:
		$Sprite.self_modulate = Color(225,225,225)
		var t = Timer.new()
		t.set_wait_time(.2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		$Sprite.self_modulate = Color(1,1,1)
		health -= damage
		if health <= 0:
			die()
		
		
		
func die():
	
	#setup for animation, prevents movement and emits signal
	set_physics_process(false)
	anim.play("dead")
	can_move = false
	atk_timer.stop()
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	emit_signal("dead")
	queue_free()



func animate():
	if velocity.x > velocity.y and velocity.x > 0 :
		if anim.current_animation != "walk_right":
			anim.play("walk_right")
	if velocity.y > velocity.x and velocity.x > 0 :
		if anim.current_animation != "walk_front":
			anim.play("walk_front")
	if velocity.x > velocity.y and velocity.x < 0 :
		if anim.current_animation != "walk_back":
			anim.play("walk_back")
	if velocity.x < velocity.y and velocity.x < 0 :
		if anim.current_animation != "walk_left":
			anim.play("walk_left")
	if velocity.x > 0 and velocity.y == 0:
		if anim.current_animation != "walk_right":
			anim.play("walk_right")
	if velocity.x < 0 and velocity.y == 0:
		if anim.current_animation != "walk_left":
			anim.play("walk_left")
	if velocity.y > 0 and velocity.x == 0:
		if anim.current_animation != "walk_front":
			anim.play("walk_front")
	if velocity.y < 0 and velocity.x == 0:
		if anim.current_animation != "walk_back":
			anim.play("walk_back")
			





