extends Control
class_name TypingLevel

const CURSOR_WIDTH := 1

@export var cursor: TextCursor
@export var typing_tasks: Array[TypingTask]

var current_task_index := 0
# TODO: NECESSARY?
var is_complete = false

func _ready() -> void:
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

func on_window_resized():
	_update_cursor()

func _handle_char(typed_char: String) -> void:
	if current_task_index >= typing_tasks.size():
		return
	var box: TypingTask = typing_tasks[current_task_index]
	if box.type_next(typed_char):
		_update_cursor()
		if box.is_task_complete():
			current_task_index += 1
			if current_task_index >= typing_tasks.size():
				_complete()
				return
			_update_cursor()
	else:
		#TODO: Handle typing errors
		pass

func _update_cursor() -> void:
	var box: TypingTask = typing_tasks[current_task_index]
	cursor.size = Vector2(CURSOR_WIDTH * box.get_font_size() / 16, box.get_font_size())
	cursor.position = box.get_cursor_position()
	cursor.show_cursor()

func _complete() -> void:
	is_complete = true
	cursor.hide_cursor()
