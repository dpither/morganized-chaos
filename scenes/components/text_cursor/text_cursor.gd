class_name TextCursor
extends ColorRect

@export var text_cursor_timer: Timer

func _ready() -> void:
  text_cursor_timer.timeout.connect(_on_text_cursor_timer_timeout)
  anchor_left = 0
  anchor_top = 0
  anchor_right = 0
  anchor_bottom = 0

func show_cursor() -> void:
  text_cursor_timer.start()
  visible = true

func hide_cursor() -> void:
  text_cursor_timer.stop()
  visible = false

func _on_text_cursor_timer_timeout() -> void:
  visible = !visible