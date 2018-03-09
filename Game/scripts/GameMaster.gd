extends Node2D

var enemies
var enemy_scenes = ["res://scenes/enemy1.tscn", "res://scenes/enemy2.tscn", "res://scenes/enemy3.tscn"]
var enemie_types = []

func _ready():
	for i in range(len(enemy_scenes)):
		enemie_types.append(i)
		enemie_types[i] = load(enemy_scenes[i])
	start_wave()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func start_wave():
	enemies = randi()%10+1
	if enemies < 3:
		enemies += 3
	for i in range(enemies):
		genrate_random_enemie()
	
	
	
func generate_random_enemie():
	var type = randi()%3
	var enemy = enemy_types[type].instance()
	# spawn between (100,100) and (5120,3175)
	enemy.position = Vector2(int(rand_range(100,5120)),int(rand_range(100,3175)))
	add_child(enemy)
	