extends Timer
class_name GameTimer

func _ready() -> void:
  wait_time = 1.0
  # TODO: REMOVE?
  start()
  GameState.game_paused.connect(_on_game_paused)
  GameState.game_resumed.connect(_on_game_resumed)
  timeout.connect(_on_game_timer_timeout)

func _on_game_timer_timeout():
  GameState.elapsed_time_changed.emit(GameState.elapsed_time+1)

func _on_game_paused() -> void:
  stop()

func _on_game_resumed() -> void:
  start()
