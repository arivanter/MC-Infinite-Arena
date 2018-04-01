extends KinematicBody2D

# player parameters

var absol_mul = 1.0 # for absolute power increase prize
var WALK_SPEED = 450.0 
var EVADE_SPEED = 25 
var evade_vect = Vector2()
var evade_timer
var knockx = 0
var knocky = 0
var velocity = Vector2()
var max_health = 100.0 
var max_mana = 100.0 
var max_stamina = 100 
var health
var mana
var stamina
var mana_regen = 15.0 
var mana_depletion = .4
var health_regen = .2 
var stam_regen = .5
var sword_power = 20.0 
var spell_mul = 1.0 
var can_move
signal dead

# prize variable array
var var_names = ["Velocidad", "HP", "Mana", "Regeneracion de mana", "Agotamiento de mana reducido", "Regeneracion de HP", "Poder de tu espada", "Poder de tu magia", "Poder total", "Stamina", "Regeneracion de stamina"]

# node variables

onready var anim = $Sprite/AnimationPlayer
onready var attack_area = $Attack_area/CollisionShape2D
onready var heal_stream = load("res://sound/heal.wav")

# state machine variables

enum STATES {WALK, ATTACK, HEAL, DIE, MAGIC, EVADE}
var current_state = null
var previous_state = null
var aux_anim_name = ""

# magic variable node

var spell_scene = load("res://scenes/spells/Fire1.tscn")



func _ready():
	
	health = max_health
	mana = max_mana
	stamina = max_stamina
	can_move = true
	$AttackParticles.emitting = false
	$HealthParticles.emitting = false
	$Attack_area/CollisionShape2D.disabled = true
	
	evade_timer = Timer.new()
	evade_timer.set_one_shot(true)
	evade_timer.wait_time = .2
	evade_timer.connect("timeout", self, "end_evade")
	add_child(evade_timer)
	
	# set initial idle position
	aux_anim_name = "walk_front"
	anim.current_animation = "walk_front"
	anim.stop()




func _physics_process(delta):
	if health <= 0 and can_move:
		_change_state(DIE)
	move_and_collide(Vector2(knockx,knocky))
	if knockx != 0 or knocky != 0:
		if knockx > 0:
			knockx -= 1
		elif knockx < 0:
			knockx += 1
		if knocky > 0:
			knocky -= 1
		elif knocky < 0:
			knocky += 1
	if stamina < max_stamina:
		stamina += stam_regen
	# process input, checked by priority
	if (Input.is_action_just_pressed("ui_sword")):
		if can_move:
			_change_state(ATTACK)
		
	elif (Input.is_action_just_pressed("ui_magic")):
		if can_move:
			_change_state(MAGIC)
		
	elif (Input.is_action_just_pressed("ui_accept")):
		if can_move and stamina >= 25:
			_change_state(EVADE)
	
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
	
	if current_state == EVADE and not evade_timer.is_stopped():
		move_and_collide(evade_vect)
		
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
			if $AudioStreamPlayer2D.stream != heal_stream :
				$AudioStreamPlayer2D.stream = heal_stream
			heal()
		DIE:
			die()
		EVADE:
			evade()



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
	
	
	
func evade():
	stamina -= 25
	if evade_timer.is_stopped():
		evade_timer.start()
	can_move = false
	if aux_anim_name == "walk_back" and anim.current_animation != "atk_back":
		anim.play("atk_back")
		anim.seek(0.0,true)
		anim.stop()
		evade_vect = Vector2(0,-EVADE_SPEED)
			
	elif aux_anim_name == "walk_front" and anim.current_animation != "atk_front":
		anim.play("atk_front")
		anim.seek(0.0,true)
		anim.stop()
		evade_vect = Vector2(0,EVADE_SPEED)
			
	elif aux_anim_name == "walk_left" and anim.current_animation != "atk_left":
		anim.play("atk_left")
		anim.seek(0.0,true)
		anim.stop()
		evade_vect = Vector2(-EVADE_SPEED,0)
			
	elif aux_anim_name == "walk_right" and anim.current_animation != "atk_right":
		anim.play("atk_right")
		anim.seek(0.0,true)
		anim.stop()
		evade_vect = Vector2(EVADE_SPEED,0)
	
	
	
func end_evade():
	can_move = true
	anim.play(aux_anim_name)
	anim.seek(0.0,true)
	anim.stop()
	evade_vect = Vector2(0,0)
	
	
	
###################
#### attacking ####	
	
func attack():
	
	if can_move:
		attack_animation()
		$AudioStreamPlayer2D.stream = load("res://sound/sword.wav")
		$AudioStreamPlayer2D.play()
		attack_area.disabled = false
		can_move = false
		var t = Timer.new()
		t.set_wait_time(.2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		can_move = true
		attack_area.disabled = true
		
		
		
func _on_Attack_area_body_entered(body):
	if body != self and body is KinematicBody2D:
		$AudioStreamPlayer2D.stream = load("res://sound/sword_impact.wav")
		$AudioStreamPlayer2D.play()
		Input.start_joy_vibration(0,1,0,.5)
		body.hit(sword_power)
		$Camera2D.shake(.1,100,10)
		if mana < max_mana:
			mana += mana_regen
			if mana > max_mana:
				mana = max_mana



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
		
		var spell = spell_scene.instance()
		spell.connect("hit",self,"_on_spell_hit")
		
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
		spell.multiplier = spell_mul
		add_child(spell)
		
		# new instance to launch spell again



func _on_spell_hit():
	$Camera2D.shake(.1,50,15)



###########################
#### health management ####

func hit(amount):
	Input.start_joy_vibration(0,1,1,.5)
	$Camera2D.shake(.2,50,30)
	health -= amount
	if health <= 0:
		if current_state != DIE:
			_change_state(DIE)
		
	# knockback
	var x = randi()%2
	var y = randi()%2
	var mulx = randi()%2
	var muly = randi()%2
	if mulx == 0:
		mulx = -1
	if muly == 0:
		muly = -1
	knockx = x * mulx * 25
	knocky = y * muly * 25
	
	# flash
	$Sprite.self_modulate = Color(225,225,225)
	var t = Timer.new()
	t.set_wait_time(.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$Sprite.self_modulate = Color(1,1,1)



func heal():
	can_move = false
	if mana > 0 and health < max_health:
		$HealthParticles.emitting = true
		if anim.current_animation != "heal":
			anim.play("heal")
		
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		
		# heal speed and ratio
		health += health_regen
		mana -= mana_depletion
	else:
		$HealthParticles.emitting = false
		$AudioStreamPlayer2D.stop()
		anim.current_animation = "walk_front"
		anim.seek(0.0, true)
		current_state = WALK



func _input(event):
	
	if event.is_action_released("ui_heal"):
		$HealthParticles.emitting = false
		$AudioStreamPlayer2D.stop()
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



##########################
#### power management ####

func inc_pow(stat,multiplier):
	
	if stat == 0 and WALK_SPEED * multiplier < 1500:
		WALK_SPEED *= multiplier
	elif stat == 1:
		max_health *= multiplier
	elif stat == 2:
		max_mana *= multiplier 
	elif stat == 3:
		mana_regen *= multiplier
	elif stat == 4:
		mana_depletion /= multiplier
	elif stat == 5:
		health_regen *= multiplier
	elif stat == 6:
		sword_power *= multiplier
	elif stat == 7:
		spell_mul *= multiplier
	elif stat == 8:
		absol_mul *= multiplier
		absol_power_application()
	elif stat == 9:
		stam_regen *= multiplier
	elif stat == 10:
		max_stamina *= multiplier 



func absol_power_application():
	if WALK_SPEED * absol_mul < 1500:
		WALK_SPEED *= absol_mul
	EVADE_SPEED *= absol_mul
	max_health *= absol_mul
	max_mana *= absol_mul
	max_stamina *= absol_mul
	mana_regen *= absol_mul
	health_regen *= absol_mul
	stam_regen *= absol_mul
	sword_power *= absol_mul
	spell_mul *= absol_mul
	mana_depletion /= absol_mul