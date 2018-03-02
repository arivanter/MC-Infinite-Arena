extends KinematicBody2D

# enemy parameters 

#onready var player = get_parent().get_node("player")
var multiplier = 1
var power = 25
var health = 100
var can_move
var move_dir_rand
var WALK_SPEED = 300
var velocity = Vector2()
var timer = null
var walk_delay = 1

# state machine variables

enum STATES {IDLE, WALK, ATTACK, DIE, MAGIC}
var current_state = null
var previous_state = null



func _ready():
	
	_change_state(WALK)
	can_move = true
	health *= multiplier
	power *= multiplier
	
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.wait_time = walk_delay
	timer.connect("timeout", self, "on_timer_complete")
	add_child(timer)
	select_random_dir()



func _process(delta):
	
	if can_move:
		if velocity != Vector2(0,0):
			_change_state(WALK)
	if timer.is_stopped():
		timer.start()
			
			
		# reset step to idle after finishing walk
#		elif current_state == WALK and move_dir_rand == 0:
#			if anim.current_animation != "":
#				anim.seek(0.0,true)



#######################
#### state machine ####

func _change_state(new_state):
	
	previous_state = current_state
	current_state = new_state

	# initialize/enter the state
	match new_state:
		WALK:
#			movement_animation(velocity)
#			aux_anim_name = anim.current_animation # for animation selection (attack and magic)
			move_and_slide(velocity, Vector2(0,0))
			
		ATTACK:
			attack()
		MAGIC:
			magic_spell()
		DIE:
			die()
	
	
	
##################
#### movement ####

func on_timer_complete():
	select_random_dir()



func select_random_dir():
	move_dir_rand = randi()%4+1
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



################
#### attack ####

func attack():
	pass
	
	
	
#func _on_Area2D_body_entered( body ):
#	if body == player:
#		player.hit(power)
		
		
		
# magic
func magic_spell():
	pass
	
	
	
###########################
#### health management ####

func hit(damage):
	health -= damage
	if health <= 0:
		_change_state(DIE)
		
		
		
func die():
	
	#setup for animation, prevents movement and emits signal
	can_move = false
#	anim.play("die")
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	emit_signal("dead")



