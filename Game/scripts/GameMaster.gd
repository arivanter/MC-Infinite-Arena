extends Node2D

var enemies
var remaining_enemies
var enemy_scenes = ["res://scenes/enemy1.tscn", "res://scenes/enemy2.tscn", "res://scenes/enemy3.tscn"]
var enemy_types = []
var wave = 1

func _ready():
	randomize()
	hide()
	$AnimationPlayer.play("fade")
	show()
	$player/PauseMenu.hide()
	$player/GameOver.hide()
	$player/EndWave.hide()
	for i in range(len(enemy_scenes)):
		enemy_types.append(i)
		enemy_types[i] = load(enemy_scenes[i])
	$player/HUD/WaveDisplay.hide()
	$player/EndWave.connect('confirmed',self,'start_wave')
	start_wave()



func _process(delta):
	$player/HUD/CurrRemEnemies.text = str(remaining_enemies) + ' / ' + str(enemies)
	
	

func start_wave():
	
	wave_display()
	
	enemies = randi()%10+1
	if enemies < 3:
		enemies += 3
		
	#enemies = 1
		
	for i in range(enemies):
		generate_random_enemy()
	wave += 1
	remaining_enemies = enemies
	
	
	
func generate_random_enemy():
#	var type = randi()%3
	var type = 0
	var enemy = enemy_types[type].instance()
	enemy.scale = Vector2(.2,.2)
	$Path2D/PathFollow2D.unit_offset = rand_range(0,1)
	# spawn between (100,100) and (5120,3175)
	enemy.position = $Path2D/PathFollow2D.position
	print ($Path2D/PathFollow2D.position)
	enemy.multiplier += float(float(wave)/5)
	enemy.connect('dead', self, '_on_enemy_dead')
	add_child(enemy)
	


func wave_display():
	
	$player/HUD/WaveDisplay.text = "Oleada "+str(wave)
	$player/HUD/CurWave.text = str(wave)
	$player/HUD/WaveDisplay/AnimationPlayer.play("fade")
	$player/HUD/WaveDisplay.show()
	


func _on_player_dead():
	get_tree().paused = true
	$player/GameOver.show()



func _on_enemy_dead():
	remaining_enemies -= 1
	if remaining_enemies <= 0:
		end_wave()
		
		
		
func end_wave():
	$player/EndWave/secret_prize.hide()
	$player/EndWave.show()



func _input(event):
	if event.is_action_pressed("ui_pause"):
		$player/PauseMenu.show()
		get_tree().paused = true