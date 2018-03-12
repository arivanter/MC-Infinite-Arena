extends Node2D

var topscore = 100

func _ready():
	randomize()
	$AnimationPlayer.play("fadein")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PlayButton_pressed():
	$AnimationPlayer.play("fadeout")
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	get_tree().change_scene("res://scenes/GameMaster.tscn")


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://scenes/settings.tscn")
	
	
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		get_tree().quit()

