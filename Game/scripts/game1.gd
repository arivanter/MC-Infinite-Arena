extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	hide()
	$AnimationPlayer.play("fadein")
	show()
	$player/PauseMenu.hide()
	$player/GameOver.hide()
	$player/EndWave.hide()

func _process(delta):
	if Input.is_action_pressed("ui_pause"):
		$player/PauseMenu.show()
		get_tree().paused = true
	
	

func _on_player_dead():
	$player/GameOver.show()
	
	
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		$player/EndWave.show()


func _on_enemy1_dead():
	$player/EndWave.show()
