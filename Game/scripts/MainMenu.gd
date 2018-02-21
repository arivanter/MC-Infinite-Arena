extends Node2D

var topscore = 100

func _ready():
	#$Loading.hide()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PlayButton_pressed():
	#$Loading.show()
	get_tree().change_scene("res://scenes/game1.tscn")


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://scenes/settings.tscn")

