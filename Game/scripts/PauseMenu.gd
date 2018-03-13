extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Sure.hide()


#func _process(delta):
#	if Input.is_action_just_pressed("ui_pause"):
#		_on_cotinue_pressed()
	
	
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		_on_cotinue_pressed()



func _on_exit_pressed():
	$Sure.show()


func _on_cotinue_pressed():
	get_tree().paused = false
	hide()


func _on_pause_pressed():
	get_tree().paused = false
	hide()


func _on_yes_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_no_pressed():
	$Sure.hide()
