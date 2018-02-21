extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	$PauseMenu.hide()
	$GameOver.hide()

func _process(delta):
	$World/player/HUD/health.value = $World/player.health
	$World/player/HUD/mana.value = $World/player.mana
	if Input.is_action_pressed("ui_pause"):
		$World/player/HUD.emit_signal("pause")
	
	

func _on_HUD_pause():
	$PauseMenu.show()
	$enemy1.hide()
	get_tree().paused = true
	


func _on_player_dead():
	$GameOver.show()
