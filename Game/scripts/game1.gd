extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	$PauseMenu.hide()
	$GameOver.hide()
	$enemy1.show()

func _process(delta):
	$player/HUD/health.value = $player.health
	$player/HUD/mana.value = $player.mana
	if Input.is_action_pressed("ui_pause"):
		$player/HUD.emit_signal("pause")
	
	

func _on_HUD_pause():
	$PauseMenu.show()
	$enemy1.hide()
	get_tree().paused = true
	


func _on_player_dead():
	$GameOver.show()
