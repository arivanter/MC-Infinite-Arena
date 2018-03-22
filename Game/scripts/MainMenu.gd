extends Node2D

var topscore = 100

func _ready():
	randomize()
	$AnimationPlayer.play("fadein")
	global.max_wave = global.load_game()
	global.wave = 1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PlayButton_pressed():
	if global.max_wave != null:
		if global.max_wave >= 5:
			$WaveSelect.show()
		else:
			play()
	else:
		play()


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://scenes/settings.tscn")
	
	
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		global.save_game()
		get_tree().quit()

func play():
	$AnimationPlayer.play("fadeout")
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	get_tree().change_scene("res://scenes/GameMaster.tscn")