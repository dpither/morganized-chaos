extends Node

signal pause_changed(is_paused: bool)
signal elapsed_time_changed(new_time: int)
signal level_updated(level_id: String, accuracy: float, duration: int, is_complete: bool)
signal level_unlocked(level_data: LevelData)
signal game_over(tasks_complete: int, accuracy: float, duration: int)
signal typed_incorrect()

const MINUTES_PER_GAME_SECOND := 1
const ERROR_PENALTY := 5
const MAX_SCORE := 960

var levels: Array[LevelData] = [
  load("res://resources/level_data/notepad_brainstorm.tres"),
  load("res://resources/level_data/notepad_mechanics.tres"),
  load("res://resources/level_data/godot_new_project.tres"),
  load("res://resources/level_data/vscode_level.tres"),
  load("res://resources/level_data/vscode_task.tres"),
]


var elapsed_time := 0 # MEASURED IN SECONDS (LOWER IS BETTER)
var num_levels_complete := 0
var is_paused := false
var is_game_over := false

var _login_scene := load("res://scenes/login/login.tscn")

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
	var level := _get_level_data(level_id)
	add_time(ERROR_PENALTY * level.mistake_multiplier)

func add_time(time_added: int) -> void:
	elapsed_time = min(MAX_SCORE, elapsed_time + time_added)
	elapsed_time_changed.emit(elapsed_time)
	if elapsed_time == MAX_SCORE:
		_game_over()

func update_level(level_id: String, accuracy: float, duration: int, is_complete: bool) -> void:
	var level := _get_level_data(level_id)

	if not level:
		return

	level.accuracy = accuracy
	level.duration = duration
	level_updated.emit(level_id, accuracy, duration, is_complete)

	if is_complete:
		level.is_completed = true
		num_levels_complete += 1
		if num_levels_complete == levels.size():
			_game_over()
		_update_unlocks()

func time_to_string(duration: int) -> String:
	var hours := (duration % 3600 / 60)
	var minutes := (duration % 60)
	return "%02d:%02d" % [hours, minutes]

func retry() -> void:
	for level in levels:
		level.is_completed = false
		level.accuracy = 0.0
		level.duration = 0
		level.is_unlocked = level.prerequisites.size() == 0

	num_levels_complete = 0
	elapsed_time = 0
	is_game_over = false
	elapsed_time_changed.emit(elapsed_time)
	get_tree().change_scene_to_packed(_login_scene)
	return

func _game_over() -> void:
	is_game_over = true
	game_over.emit()

func _get_level_data(level_id: String) -> LevelData:
	for level in levels:
		if level.id == level_id:
			return level
	
	push_warning("No level with id: " + level_id)
	return null

func _update_unlocks() -> void:
	var unlocked_levels := levels.filter(_is_level_unlocked)

	for level in levels:
		if not level.is_unlocked:
			var prerequisites_completed := true
			for prerequisite in level.prerequisites:
				if unlocked_levels.find(prerequisite) == -1 or not prerequisite.is_completed:
					prerequisites_completed = false
					break

			if prerequisites_completed:
				level.is_unlocked = true
				level_unlocked.emit(level)

func _is_level_unlocked(level_data: LevelData) -> bool:
	return level_data.is_unlocked
