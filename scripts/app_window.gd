extends Control
class_name AppWindow

signal request_close(window: AppWindow)
signal request_minimize(window: AppWindow)
signal request_restore(window: AppWindow)
signal request_focus(window: AppWindow)

@export var close_button: Button
@export var maximize_button: Button
@export var minimize_button: Button
@export var title_bar: PanelContainer
@export var icon: TextureRect
@export var title: Label
@export var content: Node2D

var dragging := false
var drag_offset := Vector2.ZERO

var is_maximized := false
var prev_position := Vector2.ZERO
var prev_size := Vector2.ZERO

func _ready():
	title_bar.gui_input.connect(_on_title_bar_pressed)
	minimize_button.pressed.connect(_on_minimize_pressed)
	maximize_button.pressed.connect(_on_maximize_pressed)
	close_button.pressed.connect(_on_close_pressed)

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("request_focus", self)

func _on_title_bar_pressed(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
				emit_signal("request_focus", self)
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		if is_maximized:
			return
		global_position = (get_global_mouse_position() - drag_offset).clamp(Vector2.ZERO,get_parent_area_size()-size)

func toggle_maximize():
	if not is_maximized:
		prev_position = global_position
		prev_size = size
		global_position = Vector2.ZERO
		size = get_parent_area_size()
		maximize_button.icon = get_theme_icon("window_restore_down", "IconButton")
		is_maximized = true
	else:
		global_position = prev_position
		size = prev_size 
		maximize_button.icon = get_theme_icon("window_maximize", "IconButton")
		is_maximized = false

func minimize():
	hide()
	emit_signal("request_minimize", self)

func restore():
	show()
	emit_signal("request_restore", self)
	emit_signal("request_focus", self)

#TODO: Maybe remove this since app windows will be built by me and then instantiated by name perhaps
func set_title(new_title: String):
	title.text = new_title

func set_icon(new_icon: Texture2D):
	icon.texture = new_icon

func set_focus(is_focused: bool):
	if is_focused:
		title.set("theme_override_colors/font_color", get_theme_color("font_color", "TitleBar"))
	else:
		title.set("theme_override_colors/font_color", get_theme_color("font_disabled_color", "TitleBar"))

func _on_close_pressed():
	emit_signal("request_close", self)

func _on_maximize_pressed():
	emit_signal("request_focus", self)
	toggle_maximize()

func _on_minimize_pressed():
	minimize()
