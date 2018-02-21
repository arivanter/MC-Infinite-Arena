extends KinematicBody2D

var max_health = 100
var max_mana = 100
var health
var mana
var can_momve
signal dead

export var WALK_SPEED = 300
onready var anim = $Sprite/AnimationPlayer

enum STATES {WALK, ATTACK, HEAL, DIE}
var current_state = null
var previous_state = null
var aux_anim_name = ""



func _ready():
	health = max_health
	mana = max_mana
	can_momve = true
	$AttackParticles.emitting = false
	$HealthParticles.emitting = false
	
	# set initial idle position
	anim.current_animation = "walk_front"
	anim.stop()
	
	
	
func _physics_process(delta):
	
	var velocity = Vector2()
	
	# process input, checked by priority
	if (Input.is_action_pressed("ui_sword")):
		_change_state(ATTACK)
	
	elif (Input.is_action_pressed("ui_heal")):
		_change_state(HEAL)
	
	elif (Input.is_action_pressed("ui_left")):
		velocity.x = - WALK_SPEED
		velocity.y = 0
		
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =   WALK_SPEED
		velocity.y = 0
		
	elif (Input.is_action_pressed("ui_up")):
		velocity.y = - WALK_SPEED
		velocity.x = 0
		
	elif (Input.is_action_pressed("ui_down")):
		velocity.y =   WALK_SPEED
		velocity.x = 0
		
	
	
	# reduce vector to 0 to stop moving
	else:
		velocity.x = 0
		velocity.y = 0
		
		
	if can_momve:
		if velocity != Vector2(0,0):
			movement_animation(velocity)
			_change_state(WALK)
			
		# reset step to idle after releasing walk input
		elif current_state == WALK:
			if anim.current_animation != "":
				anim.seek(0.0,true)
				
		move_and_slide(velocity, Vector2(0,0))
		


func _change_state(new_state):
	
	previous_state = current_state
	current_state = new_state

	# initialize/enter the state
	match new_state:
		WALK:
			aux_anim_name = anim.current_animation # for animation selection
		ATTACK:
			attack()
		HEAL:
			heal()
		DIE:
			die()



func movement_animation(velocity):
	
	# select directional movement animation
	if velocity.y < 0:
		if anim.current_animation != "walk_back":
			anim.play("walk_back")
	elif velocity.y > 0:
		if anim.current_animation != "walk_front":
			anim.play("walk_front")
	elif velocity.x < 0:
		if anim.current_animation != "walk_left":
			anim.play("walk_left")
	elif velocity.x > 0:
		if anim.current_animation != "walk_right":
    		anim.play("walk_right")
	
	
	
func attack_animation():
	
	# select directional attack animation
	if can_momve:
		if aux_anim_name == "walk_back" and anim.current_animation != "atk_back":
			$AttackParticles.emitting = true
			anim.play("atk_back")
				
		elif aux_anim_name == "walk_front" and anim.current_animation != "atk_front":
			$AttackParticles.emitting = true
			anim.play("atk_front")
				
		elif aux_anim_name == "walk_left" and anim.current_animation != "atk_left":
			$AttackParticles.emitting = true
			anim.play("atk_left")
				
		elif aux_anim_name == "walk_right" and anim.current_animation != "atk_right":
			$AttackParticles.emitting = true
			anim.play("atk_right")
	
	
	
func attack():
	
	attack_animation()
	#calculate attack



func heal():
	if can_momve:
		if mana > 0 and health < max_health:
			$HealthParticles.emitting = true
			if anim.current_animation != "heal":
				anim.play("heal")
				
			# heal speed and ratio
			health += .1
			mana -= .2
		else:
			$HealthParticles.emitting = false
			anim.current_animation = "walk_front"
			anim.seek(0.0, true)
			current_state = WALK
		


func _input(event):
	if event.is_action_released("ui_heal"):
		$HealthParticles.emitting = false
		anim.current_animation = "walk_front"
		anim.seek(0.0, true)
		current_state = WALK


func die():
	
	#setup for animation, prevents movement and calls game over
	can_momve = false
	anim.play("die")
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	emit_signal("dead")



#####################################################
#####################################################
########### PLACEHOLDER FOR DAMAGE PLAYER ###########
#####################################################
#####################################################
func _on_Area2D_area_entered( area ):
	damage(area)
	if health <= 0:
		_change_state(DIE)
		


func damage(area):
	if area != $Attack_area:
		health -= 25
#####################################################
#####################################################
#####################################################
#####################################################