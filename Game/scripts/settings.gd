extends CanvasLayer

var topscore = "100"

func _ready():
	$Points.text = topscore

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Reset_pressed():
	$Points.text = '0'
