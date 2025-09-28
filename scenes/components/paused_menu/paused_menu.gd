extends Control

@export var music_slider: HSlider
@export var sound_slider: HSlider
@export var resume_button: Button
@export var close_button: Button

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_WHEN_PAUSED
  music_slider.value = AudioManager.DEFAULT_MUSIC_VOLUME
  sound_slider.value = AudioManager.DEFAULT_SOUND_VOLUME
  music_slider.drag_ended.connect(_on_music_slider_drag_ended)
  sound_slider.drag_ended.connect(_on_sound_slider_drag_ended)
  close_button.pressed.connect(_resume)
  resume_button.pressed.connect(_resume)
  GameState.pause_changed.connect(_on_pause_changed)

func _gui_input(event: InputEvent) -> void:
  if event is not InputEventMouseButton:
    return
  if not event.pressed:
    return
  if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
    AudioManager.play_sound(AudioManager.SOUND_TYPE.MOUSE_CLICKED)

func _on_music_slider_drag_ended(value_changed: bool) -> void:
  if value_changed:
    AudioManager.set_music_volume(music_slider.value)

func _on_sound_slider_drag_ended(value_changed: bool) -> void:
  if value_changed:
    AudioManager.set_sound_volume(sound_slider.value)

func _resume() -> void:
  GameState.toggle_pause()

func _on_pause_changed(is_paused: bool) -> void:
  if is_paused:
    show()
  else:
    hide()