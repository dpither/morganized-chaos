class_name GlitchOverlay
extends ColorRect

const DEFAULT_GLITCH_DURATION := 0.3

var glitch_timer: Timer

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS
  glitch_timer = Timer.new()
  add_child(glitch_timer)
  GameState.typed_incorrect.connect(_on_typed_incorrect)
  glitch_timer.timeout.connect(_on_glitch_timer_timeout)

func trigger_glitch(duration: float) -> void:
  material.set("shader_parameter/enabled", true)
  glitch_timer.start(duration)

func _on_typed_incorrect() -> void:
  trigger_glitch(DEFAULT_GLITCH_DURATION)

func _on_glitch_timer_timeout() -> void:
  material.set("shader_parameter/enabled", false)
