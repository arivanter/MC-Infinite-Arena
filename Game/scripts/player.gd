extends KinematicBody2D

# player parameters

var WALK_SPEED = 300
var velocity = Vector2()
var max_health = 100
var max_mana = 100
var health
var mana
var sword_power = 25
var can_move
signal dead

# node variables

onready var anim = $Sprite/AnimationPlayer
onready var attack_area = $Attack_area/CollisionShape2D

# state machine variables

enum STATES {WALK, ATTACK, HEAL, DIE, MAGIC}
var current_state = null
var previous_state = null
var aux_anim_name = ""

#magic variable node

var spell_scene = load("res://scenes/spells/Fire1.tscn")
var spell = spell_scene.instance()



func _ready():
	
	health = max_health
	mana = max_mana
	can_move = true
	$AttackParticles.emitting = false
	$HealthParticles.emitting = false
	$Attack_area/CollisionShape2D.disabled = true
	
	# set initial idle position
	anim.current_animation = "walk_front"
	anim.stop()



func _physics_process(delta):
	
	# process input, checked by priority
	if (Input.is_action_just_pressed("ui_sword")):
		_change_state(ATTACK)
		
	elif (Input.is_action_just_pressed("ui_magic")):
		_change_state(MAGIC)
	
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
	
		
	if can_move:
		if velocity != Vector2(0,0):
			_change_state(WALK)
			
		# reset step to idle after releasing walk input
		elif current_state == WALK:
			if anim.current_animation != "":
				anim.seek(0.0,true)



#######################
#### state machine ####

func _change_state(new_state):
	
	previous_state = current_state
	current_state = new_state

	# initialize/enter the state
	match new_state:
		WALK:
			movement_animation(velocity)
			aux_anim_name = anim.current_animation # for animation selection (attack and magic)
			move_and_slide(velocity, Vector2(0,0))
		ATTACK:
			attack()
		MAGIC:
			magic_spell()
		HEAL:
			heal()
		DIE:
			die()



##################
#### movement ####

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
	
	
	
###################
#### attacking ####	
	
func attack():
	
	if can_move:
		attack_animation()
		attack_area.disabled = false
		var t = Timer.new()
		t.set_wait_time(.2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		attack_area.disabled = true
		
		
		
func _on_Attack_area_body_entered(body):
	if body != self and body is KinematicBody:
		body.hit(sword_power)



func attack_animation():
	
	# select directional attack animation
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



# magic
func magic_spell():
	
	if can_move and mana > 0:
		if aux_anim_name == "walk_back":
			spell.direction = Vector2 (0,-1)
			anim.play("atk_back")

		elif aux_anim_name == "walk_front":
			spell.direction = Vector2 (0,1)
			anim.play("atk_front")

		elif aux_anim_name == "walk_left":
			spell.direction = Vector2 (-1,0)
			anim.play("atk_left")

		elif aux_anim_name == "walk_right":
			spell.direction = Vector2 (1,0)
			anim.play("atk_right")
		
		mana -= spell.cost
		add_child(spell)
		
		# new instance to launch spell again
		spell = spell_scene.instance()



###########################
#### health management ####

func hit(amount):
	
	health -= amount
	if health <= 0:
		_change_state(DIE)



func heal():
	
	if mana > 0 and health < max_health:
		$HealthParticles.emitting = true
		can_move = false
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
		can_move = true
		anim.current_animation = "walk_front"
		anim.seek(0.0, true)
		current_state = WALK



func die():
	
	#setup for animation, prevents movement and emits signal
	can_move = false
	anim.play("die")
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	emit_signal("dead")
