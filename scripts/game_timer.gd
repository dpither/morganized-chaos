class_name GameTimer
extends Timer

func _ready() -> void:
  wait_time = 1.0
  start()
  timeout.connect(_on_game_timer_timeout)

func _on_game_timer_timeout() -> void:
  GameState.add_time(1)
