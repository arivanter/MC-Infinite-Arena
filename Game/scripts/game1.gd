extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	$AnimationPlayer.play("fadein")
	$player/PauseMenu.hide()
	$player/GameOver.hide()

func _process(delta):
	if Input.is_action_pressed("ui_pause"):
		$player/PauseMenu.show()
		get_tree().paused = true
	
	

func _on_player_dead():
	$player/GameOver.show()
