extends Node

var wave = 1
var max_wave = 0

func save_game():
    var save_game = File.new()
    save_game.open("user://savegame.sav", File.WRITE)
    save_game.store_line(str(max_wave))
    save_game.close()
	
func load_game():
	var file = File.new()
	if not file.file_exists("user://savegame.sav"):
		file.open("user://savegame.sav", File.WRITE)
		file.store_line("0")
		file.close()
		return
	file.open("user://savegame.sav", file.READ)
	var content = file.get_as_text()
	file.close()
	max_wave = int(content)
	return max_wave