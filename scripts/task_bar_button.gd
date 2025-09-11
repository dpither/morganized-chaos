extends Button
class_name TaskBarButton

var task_name := ""
var task_icon: Texture2D

func _ready() -> void:
	if task_icon:
		icon = task_icon
	text = task_name

func set_focus(is_focused:bool) -> void:
	if is_focused:
		button_pressed = true
		add_theme_font_override("font",get_theme_font("font_focused", "TaskBarButton"))
		add_theme_stylebox_override("pressed",get_theme_stylebox("is_focused", "TaskBarButton"))
	else:
		button_pressed = false
		remove_theme_font_override("font")
		remove_theme_stylebox_override("pressed")
