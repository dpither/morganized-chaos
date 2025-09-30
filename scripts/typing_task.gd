class_name TypingTask
extends RichTextLabel

@export var typed_color: Color
@export var not_typed_color: Color
@export var highlight_color: Color
@export var hide_typed := false
@export var highlight := false
var typed_count := 0

func _ready() -> void:
	bbcode_enabled = true
	mouse_filter = Control.MOUSE_FILTER_PASS
	_update_task()

func type_next(typed_char: String) -> bool:
	if typed_count < text.length() and typed_char == text[typed_count]:
		typed_count += 1
		_update_task()
		return true

	return false

func get_font_size() -> int:
	return get_theme_font_size("normal_font_size")

func is_task_complete() -> bool:
	return typed_count >= text.length()

func get_cursor_position() -> Vector2:
	if typed_count == 0:
		return global_position

	var font := get_theme_font("normal_font")
	var line := get_character_line(typed_count)
	var y_offset := get_line_offset(line)
	var line_start_index := get_line_range(line).x
	var line_text := text.substr(line_start_index, typed_count - line_start_index)
	var x_offset := font.get_string_size(line_text, horizontal_alignment, -1, get_font_size()).x

	if line_start_index != typed_count:
		x_offset -= 1

	return global_position + Vector2(x_offset, y_offset)

func _update_task() -> void:
	var typed_text := ""
	
	if hide_typed:
		for i in typed_count:
			typed_text += "*"
	else:
		typed_text = text.substr(0, typed_count)
	
	var not_typed_text := text.substr(typed_count)
	clear()
	if highlight:
		push_bgcolor(highlight_color)
	push_color(typed_color)
	add_text(typed_text)
	pop()
	push_color(not_typed_color)
	add_text(not_typed_text)
	pop()
	if highlight:
		pop()
