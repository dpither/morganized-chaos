extends Control

@export var retry_button: Button
@export var logout_button: Button
@export var info_label: Label
@export var tasks_complete_label: Label
@export var duration_label: Label
@export var accuracy_label: Label
var app_window: AppWindow

func _ready() -> void:
  _set_data()
  retry_button.pressed.connect(_retry)
  logout_button.pressed.connect(_logout)

func _retry() -> void:
  GameState.retry()

func _logout() -> void:
  get_tree().quit(0)

func _set_data() -> void:
  tasks_complete_label.text = "%d/%d" % [GameState.num_levels_complete, GameState.levels.size()]

  duration_label.text = GameState.time_to_string(GameState.elapsed_time)
  
  var total_accuracy = 0.0
  for level in GameState.levels:
    total_accuracy += level.accuracy
  total_accuracy /= GameState.levels.size()
  accuracy_label.text = "%.1f%%" % total_accuracy
  # All tasks done
  if GameState.num_levels_complete == GameState.levels.size():
    info_label.text = "All tasks for today are finished.\nGreat job! :D"
  else:
    info_label.text = "Time to get some sleep, tasks can be finished tomorrow.\nGood effort! :)"