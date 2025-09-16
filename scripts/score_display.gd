extends Label

const MINUTES_PER_DAY := 1440
const MINUTES_PER_HOUR := 60
const GAME_SECONDS_PER_HOUR := MINUTES_PER_HOUR / GameState.MINUTES_PER_GAME_SECOND
const START_TIME = "12:00 AM"

func _ready() -> void:
  GameState.elapsed_time_changed.connect(_on_elapsed_time_changed)
  text = START_TIME

func _on_elapsed_time_changed(new_time: int) -> void:
  _display_time(new_time)

func _display_time(new_time: int) -> void:
  var time_text = ""
  var hours = new_time / GAME_SECONDS_PER_HOUR
  var minutes = new_time - (hours * GAME_SECONDS_PER_HOUR) * GameState.MINUTES_PER_GAME_SECOND

  var suffix = "PM" if hours % 24 >= 12 else "AM"
  hours = ((hours + 11) % 12 + 1)
  # time_text += "0" + str(hours) if hours < 10 else str(hours)
  time_text += str(hours)
  time_text += ":"
  time_text += "0" + str(minutes) if minutes < 10 else str(minutes)
  time_text += " " + suffix

  text = time_text
