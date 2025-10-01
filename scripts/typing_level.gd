class_name TypingLevel
extends Control

const CURSOR_WIDTH := 1

@export var cursor: TextCursor
@export var typing_tasks: Array[TypingTask]
@export var level_focused := false
@export var scroll_container: ScrollContainer
var app_window: AppWindow
var current_task_index := 0
var num_correct := 0
var num_typed := 0
var start_time: int
var is_complete := false

func _ready() -> void:
	resized.connect(on_window_resized)
	if scroll_container:
		scroll_container.get_v_scroll_bar().gui_input.connect(_on_scrollbar_gui_input)
	start_time = GameState.elapsed_time

func _process(_delta: float) -> void:
	if cursor.visible:
		_update_cursor()

func _unhandled_input(event: InputEvent) -> void:
	if GameState.is_game_over:
		return

	if not level_focused or is_complete:
		return

	if event is not InputEventKey:
		return

	if not event.pressed:
		return

	if OS.is_keycode_unicode(event.keycode):
		var typed_char := String.chr(event.unicode)
		# print("Typed: " + typed_char)
		_handle_char(typed_char)

func on_window_resized() -> void:
	await get_tree().process_frame
	_update_cursor()

func set_focus(is_focused: bool) -> void:
	level_focused = is_focused
	if is_complete:
		return
	
	if is_focused:
		cursor.show_cursor()
	else:
		cursor.hide_cursor()

func _on_scroll_value_changed(_value: float) -> void:
	await get_tree().process_frame
	_update_cursor()

func _handle_char(typed_char: String) -> void:
	if current_task_index >= typing_tasks.size():
		return
	
	num_typed += 1
	var task: TypingTask = typing_tasks[current_task_index]

	# Typed correct
	if task.type_next(typed_char):
		AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_CORRECT)
		num_correct += 1
		if task.is_task_complete():
			current_task_index += 1

			if current_task_index >= typing_tasks.size():
				_complete()
				return

		_update_cursor()
		cursor.show_cursor()
		
	# Typed incorrect
	else:
		AudioManager.play_sound(AudioManager.SOUND_TYPE.TYPED_INCORRECT)
		if app_window:
			GameState.type_incorrect(app_window.get_app_id())

	if scroll_container:
		_scroll_to_cursor()
	
	GameState.update_level(app_window.get_app_id(), (float(num_correct) / num_typed) * 100, GameState.elapsed_time - start_time, false)

func _update_cursor() -> void:
	if current_task_index >= typing_tasks.size():
		cursor.hide_cursor()
		return

	var task: TypingTask = typing_tasks[current_task_index]
	var scale_factor := task.get_font_size() / 16
	cursor.color = task.typed_color
	cursor.size = Vector2(CURSOR_WIDTH * scale_factor, task.get_font_size() - (scale_factor) * 3)
	cursor.global_position = task.get_cursor_position() + Vector2(0, 1 + (scale_factor - 1) * 2)

func _complete() -> void:
	is_complete = true
	cursor.hide_cursor()
	app_window.close()
	AudioManager.play_sound(AudioManager.SOUND_TYPE.LEVEL_COMPLETED)
	GameState.update_level(app_window.get_app_id(), (float(num_correct) / num_typed) * 100, GameState.elapsed_time - start_time, true)

func _scroll_to_cursor() -> void:
	var task: TypingTask = typing_tasks[current_task_index]
	var scale_factor := task.get_font_size() / 16
	var cursor_y := cursor.global_position.y
	var cursor_height := cursor.size.y
	var scroll_y := scroll_container.global_position.y
	var view_height := scroll_container.size.y

	var scroll_val := scroll_container.scroll_vertical

	# Need to scroll up
	if cursor_y < scroll_y:
			scroll_container.scroll_vertical = int(scroll_val - (scroll_y - cursor_y)) - (scale_factor * 3 - 2)

	# Need to scroll down
	elif cursor_y + cursor_height > scroll_y + view_height:
			scroll_container.scroll_vertical = int(scroll_val + ((cursor_y + cursor_height) - (scroll_y + view_height))) + (scale_factor * 6 - 5)

func _on_scrollbar_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if not event.pressed:
		return

	if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
		AudioManager.play_sound(AudioManager.SOUND_TYPE.MOUSE_CLICKED)
		app_window.focus_requested.emit(app_window)
