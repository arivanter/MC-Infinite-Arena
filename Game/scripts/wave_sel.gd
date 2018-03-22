extends Node2D

var wave = 1

func _ready():
	if wave % 5 == 0:
		wave = global.max_wave
	elif int(global.max_wave) < 5:
		wave = 1
	else:
		wave = global.max_wave
		while wave % 5 != 0:
			wave -= 1
	$Label2.text = str(wave)



func _on_Button_pressed():
	if wave - 5 > 0:
		wave -= 5
		$Label2.text = str(wave)
	else:
		$Label2.text = "1"
		wave = 1



func _on_Button2_pressed():
	if wave == 1 and global.max_wave >= 5:
		wave = 5
		$Label2.text = str(wave)
	
	if wave + 5 <= global.max_wave:
		wave += 5
		$Label2.text = str(wave)
	elif wave == 5:
		wave = 5
		$Label2.text = str(wave)
		



func _on_Button3_pressed():
	global.wave = wave
	get_parent().play()
	


func _on_Button4_pressed():
	hide()
