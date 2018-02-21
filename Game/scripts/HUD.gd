extends CanvasLayer

######################################
##### HUD ALWAYS CHILD OF PLAYER #####
######################################

var parent 

signal pause

func _ready():
	parent = get_parent()
	set_process(true)
	pass



func _process(delta):
	if parent != null:
		$health.max_value = parent.max_health
		$mana.max_value = parent.max_mana
		$health.value = parent.health
		$mana.value = parent.mana

