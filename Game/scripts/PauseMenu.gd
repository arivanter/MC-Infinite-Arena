extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Sure.hide()
	get_parent().get_node("enemy1").hide()


func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$cotinue.emit_signal("pressed")


func _on_exit_pressed():
	$Sure.show()


func _on_cotinue_pressed():
	get_tree().paused = false
	hide()
	get_parent().get_node("player/HUD/pause").show()
	get_parent().get_node("enemy1").show()


func _on_pause_pressed():
	get_tree().paused = false
	hide()
	get_parent().get_node("player/HUD/pause").show()
	get_parent().get_node("enemy1").show()


func _on_yes_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_no_pressed():
	$Sure.hide()
