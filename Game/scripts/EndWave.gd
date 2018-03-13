extends Node2D

onready var player = get_parent()
onready var prize = $secret_prize
var bonus_string
signal confirmed

func _ready():
	$secret_prize.hide()
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button3_pressed():
	player.mana = player.max_mana
	$secret_prize/Label.text = "Mana regenerada"
	prize.show()
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	hide()
	emit_signal('confirmed')


func _on_Button2_pressed():
	random_bonus()
	$secret_prize/Label.text = bonus_string
	prize.show()
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	hide()
	emit_signal('confirmed')


func _on_Button_pressed():
	player.health = player.max_health
	$secret_prize/Label.text = "Salud regenerada"
	prize.show()
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	hide()
	emit_signal('confirmed')

func random_bonus():
	var bonus_add = float(randi()%10+1)
	bonus_add /= 10
	var rand_val = randi()%len(player.var_names)
	bonus_add += 1
	player.inc_pow(rand_val, bonus_add)
	bonus_string = player.var_names[rand_val]+" incrementado en "+str((bonus_add-1)*100)+" porciento"