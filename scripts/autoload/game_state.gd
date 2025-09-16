extends Node

# mainly listened to be timer and emitted by pause menu
signal game_paused()
signal game_resumed()

signal elapsed_time_changed(new_time: int)
signal level_completed(level_id: String)

const MINUTES_PER_GAME_SECOND := 1
# TODO: OFF BY ONE??
const MAX_SCORE = 1440

var levels: Array[LevelData] = []
# MEASURED IN SECONDS
var elapsed_time = 0

func _ready() -> void:
	_load_levels()
	elapsed_time_changed.connect(_on_elapsed_time_changed)


func complete_level(level_id: String):
	var level = _get_level_data(level_id)
	if not level:
		return
	level.is_completed = true
	level_completed.emit(level_id)

func _load_levels() -> void:
	var path = "res://resources/level_data"
	var directory = DirAccess.open(path)
	if not directory:
		return
	for file_name in directory.get_files():
		var level_data: LevelData = load(path + "/" + file_name)
		levels.append(level_data)	
	print_debug("Loaded " + path)

func _on_elapsed_time_changed(new_time: int):
	elapsed_time = new_time

func _get_level_data(level_id: String) -> LevelData:
	for level in levels:
		if level.id == level_id:
			return level
	push_warning("No level with id: " + level_id)
	return null
