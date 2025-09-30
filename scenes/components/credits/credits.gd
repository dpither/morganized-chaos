extends Control

@export var close_button: Button
@export var open_button: Button
@export var scroll_container: ScrollContainer

func _ready() -> void:
  close_button.pressed.connect(_on_close_pressed)
  if scroll_container:
    scroll_container.get_v_scroll_bar().gui_input.connect(_on_scrollbar_gui_input)

func _on_close_pressed() -> void:
  hide()
  if open_button:
    open_button.button_pressed = false

func _on_scrollbar_gui_input(event: InputEvent) -> void:
  if event is not InputEventMouseButton:
    return

  if not event.pressed:
    return

  if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
    AudioManager.play_sound(AudioManager.SOUND_TYPE.MOUSE_CLICKED)
