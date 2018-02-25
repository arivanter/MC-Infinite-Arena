extends KinematicBody2D

onready var player = get_parent().get_node("player")
var power = 25

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered( body ):
	if body == player:
		player.hit(power)
		
