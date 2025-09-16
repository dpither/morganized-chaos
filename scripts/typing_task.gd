extends RichTextLabel
class_name TypingTask

@export var typed_color: Color
@export var not_typed_color: Color

var typed_count := 0
var raw_text := ""

func _ready() -> void:
	bbcode_enabled = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	raw_text = text
	_update_task()

func type_next(typed_char: String) -> bool:
	if typed_count < text.length() and typed_char == text[typed_count]:
		typed_count += 1
		_update_task()
		return true
	return false

func get_font_size():
	return get_theme_font_size("normal_font_size")

func is_task_complete() -> bool:
	return typed_count >= text.length()

func _update_task() -> void:
	var typed_text = raw_text.substr(0, typed_count)
	var not_typed_text = raw_text.substr(typed_count)
	clear()
	push_color(typed_color)
	add_text(typed_text)
	pop()
	push_color(not_typed_color)
	add_text(not_typed_text)
	pop()

func get_cursor_position() -> Vector2:
	var font = get_theme_font("normal_font")
	var line = get_character_line(typed_count)
	var y_offset = get_line_offset(line)
	var line_start_index = get_line_range(line).x
	var line_text = raw_text.substr(line_start_index, typed_count - line_start_index)
	var x_offset = font.get_string_size(line_text, HORIZONTAL_ALIGNMENT_LEFT, -1, get_font_size()).x
	return position + Vector2(x_offset, y_offset)