class_name TypingLevel
extends Control

const CURSOR_WIDTH := 1

@export var cursor: TextCursor
@export var typing_tasks: Array[TypingTask]
var app_window: AppWindow
var current_task_index := 0
var level_focused := false
var is_complete = false # TODO: NECESSARY?

func _ready() -> void:
	resized.connect(on_window_resized)

func _unhandled_input(event: InputEvent) -> void:
	if not level_focused or is_complete:
		return

	if event is not InputEventKey:
		return

	if not event.pressed:
		return

	if OS.is_keycode_unicode(event.keycode):
		var typed_char = String.chr(event.unicode)
		print("Typed: " + typed_char)
		_handle_char(typed_char)

func on_window_resized() -> void:
	call_deferred("_update_cursor")

func set_focus(is_focused: bool) -> void:
	level_focused = is_focused
	if is_complete:
		return
	
	if is_focused:
		call_deferred("_update_cursor")
		cursor.show_cursor()
	else:
		cursor.hide_cursor()

func _handle_char(typed_char: String) -> void:
	if current_task_index >= typing_tasks.size():
		return
	
	var box: TypingTask = typing_tasks[current_task_index]
	if box.type_next(typed_char):
		AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_CORRECT)
		if box.is_task_complete():
			current_task_index += 1
			if current_task_index >= typing_tasks.size():
				_complete()
			else:
				_update_cursor()
		else:
			_update_cursor()
	else:
		AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_INCORRECT)
		GameState.type_incorrect()

func _update_cursor() -> void:
	var box: TypingTask = typing_tasks[current_task_index]
	cursor.size = Vector2(CURSOR_WIDTH * box.get_font_size() / 16, box.get_font_size())
	cursor.global_position = box.get_cursor_position()
	cursor.show_cursor()

func _complete() -> void:
	is_complete = true
	cursor.hide_cursor()
	app_window.close()
	AudioManager.play_sound(AudioManager.SOUND_TYPE.LEVEL_COMPLETED)
	GameState.complete_level(app_window.get_app_id())
