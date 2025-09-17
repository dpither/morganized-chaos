extends Node

signal pause_changed(is_paused: bool)
signal elapsed_time_changed(new_time: int)
signal level_completed(level_id: String)
signal typed_incorrect()

const MINUTES_PER_GAME_SECOND := 1
# TODO: OFF BY ONE??
const MAX_SCORE = 1440
const TYPE_INCORRECT_PENALTY := 5

var levels: Array[LevelData] = []
# MEASURED IN SECONDS (LOWER IS BETTER)
var elapsed_time := 0
var is_paused := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_levels()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_changed.emit(is_paused)

func type_incorrect() -> void:
	typed_incorrect.emit()
	add_time(TYPE_INCORRECT_PENALTY)

func add_time(time_added: int) -> void:
	elapsed_time += time_added
	elapsed_time_changed.emit(elapsed_time)

func complete_level(level_id: String) -> void:
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

func _get_level_data(level_id: String) -> LevelData:
	for level in levels:
		if level.id == level_id:
			return level
	push_warning("No level with id: " + level_id)
	return null
