extends CanvasLayer

var topscore = global.max_wave

func _ready():
	$Points.text = str(topscore)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Back_pressed():
	global.save_game()
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Reset_pressed():
	$Points.text = '0'
	global.max_wave = 0
