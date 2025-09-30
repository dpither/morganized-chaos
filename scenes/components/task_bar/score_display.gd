extends Label

const MINUTES_PER_DAY := 1440
const MINUTES_PER_HOUR := 60
const GAME_SECONDS_PER_HOUR := MINUTES_PER_HOUR / GameState.MINUTES_PER_GAME_SECOND
const START_OFFSET := 8

func _ready() -> void:
  GameState.elapsed_time_changed.connect(_on_elapsed_time_changed)
  var suffix = "PM" if START_OFFSET % 24 >= 12 else "AM"
  text = "%d:00 %s" % [START_OFFSET, suffix]

func _on_elapsed_time_changed(new_time: int) -> void:
  _display_time(new_time)

func _display_time(new_time: int) -> void:
  var hours = (new_time / GAME_SECONDS_PER_HOUR)
  var minutes = new_time - (hours * GAME_SECONDS_PER_HOUR) * GameState.MINUTES_PER_GAME_SECOND
  hours += START_OFFSET
  var suffix = "PM" if hours % 24 >= 12 else "AM"
  hours = ((hours + 11) % 12 + 1)
  text = "%d:%02d %s" % [hours, minutes, suffix]
