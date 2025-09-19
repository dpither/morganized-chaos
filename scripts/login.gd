extends Control

const CURSOR_WIDTH := 1

@export var cursor: TextCursor
@export var password_task: TypingTask
@export var glitch_overlay: GlitchOverlay
var is_complete = false

func _ready() -> void:
  await get_tree().process_frame
  _update_cursor()

func _unhandled_input(event: InputEvent) -> void:
  if is_complete:
    return

  if event is not InputEventKey:
    return
  
  if not event.pressed:
    return

  if OS.is_keycode_unicode(event.keycode):
    var typed_char = String.chr(event.unicode)
    print("Typed: " + typed_char)
    _handle_char(typed_char)

func _handle_char(typed_char: String) -> void:
  if password_task.type_next(typed_char):
    AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_CORRECT)
    if password_task.is_task_complete():
      _login()
    else:
      _update_cursor()
  else:
    AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_INCORRECT)
    glitch_overlay.trigger_glitch(glitch_overlay.DEFAULT_GLITCH_DURATION)

func _update_cursor() -> void:
  cursor.position = password_task.get_cursor_position() + Vector2(0, 1)
  cursor.show_cursor()

func _login() -> void:
  is_complete = true
  cursor.hide_cursor()
  AudioManager.play_sound(AudioManager.SOUND_TYPE.LEVEL_COMPLETED)
  # TODO: Switch to desktop