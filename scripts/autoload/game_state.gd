extends Node

signal pause_changed(is_paused: bool)
signal elapsed_time_changed(new_time: int)
signal level_completed(level_id: String, accuracy: float, duration: int)
signal game_over()
signal game_complete()
signal typed_incorrect()

const MINUTES_PER_GAME_SECOND := 1
const TYPE_INCORRECT_PENALTY := 5
const MAX_SCORE = 1440 # TODO: OFF BY ONE??

var levels: Array[LevelData] = [
  # load("res://resources/level_data/test_level2.tres"),
  load("res://resources/level_data/brainstorm.tres"),
  load("res://resources/level_data/mechanics.tres"),
	load("res://resources/level_data/test_level.tres"),
]

var elapsed_time := 0 # MEASURED IN SECONDS (LOWER IS BETTER)
var num_levels_complete := 0
var is_paused := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_changed.emit(is_paused)

func type_incorrect(level_id: String) -> void:
	typed_incorrect.emit()
	var level = _get_level_data(level_id)
	add_time(TYPE_INCORRECT_PENALTY * level.mistake_multiplier)

func add_time(time_added: int) -> void:
	if elapsed_time + time_added > MAX_SCORE:
		elapsed_time = MAX_SCORE
		_game_over()
		return
	elapsed_time += time_added
	elapsed_time_changed.emit(elapsed_time)

func complete_level(level_id: String, accuracy: float, duration: int) -> void:
	var level = _get_level_data(level_id)

	if not level:
		return

	level.is_completed = true
	level.accuracy = accuracy
	level.duration = duration
	level_completed.emit(level_id, accuracy, duration)
	num_levels_complete += 1
	if num_levels_complete == levels.size():
		_game_complete()

func time_to_string(duration: int) -> String:
	var hours = (duration % 3600 / 60)
	var minutes = (duration % 60)
	return "%02d:%02d" % [hours, minutes]

func _game_complete() -> void:
	game_complete.emit()
	print(time_to_string(elapsed_time))

func _game_over() -> void:
	game_over.emit()
	print("U SUCK")

func _get_level_data(level_id: String) -> LevelData:
	for level in levels:
		if level.id == level_id:
			return level
	
	push_warning("No level with id: " + level_id)
	return null
