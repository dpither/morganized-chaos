extends Control
class_name AppWindow

signal window_closed(window: AppWindow)
signal window_minimized(window: AppWindow)
signal focus_requested(window: AppWindow)

@export var close_button: Button
@export var maximize_button: Button
@export var minimize_button: Button
@export var title_bar: PanelContainer
@export var icon: TextureRect
@export var title: Label
@export var content_root: Control
var content: Control
var window_manager: WindowManager
var is_maximized := false

var _id: String
var _can_close = true
var _dragging := false
var _drag_offset := Vector2.ZERO
var _prev_position := Vector2.ZERO
var _prev_size := Vector2.ZERO

func _ready() -> void:
	title_bar.gui_input.connect(_on_title_bar_pressed)
	minimize_button.pressed.connect(_on_minimize_pressed)
	maximize_button.pressed.connect(_on_maximize_pressed)
	close_button.pressed.connect(_on_close_pressed)
	focus_requested.emit(self)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			AudioManager.play_sfx(AudioManager.Sfx.mouse_click)
			focus_requested.emit(self)

func _on_title_bar_pressed(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_dragging = true
				_drag_offset = get_global_mouse_position() - global_position
			else:
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		if is_maximized:
			return
		global_position = (get_global_mouse_position() - _drag_offset).clamp(Vector2.ZERO, get_parent_area_size() - size)

func toggle_maximize() -> void:
	if not is_maximized:
		_prev_position = global_position
		_prev_size = size
		global_position = Vector2.ZERO
		size = get_parent_area_size()
		maximize_button.icon = get_theme_icon("window_restore_down", "TitleBarButton")
		is_maximized = true
	else:
		global_position = _prev_position
		size = _prev_size
		maximize_button.icon = get_theme_icon("window_maximize", "TitleBarButton")
		is_maximized = false

func minimize() -> void:
	hide()
	window_minimized.emit(self)

func restore() -> void:
	show()
	focus_requested.emit(self)

func get_app_id() -> String:
	return _id

func set_app_data(app_data: AppData) -> void:
	_id = app_data.id
	title.text = app_data.title
	_can_close = app_data.can_close
	if app_data.icon:
		icon.texture = app_data.icon
	else:
		icon.hide()
	
	content = app_data.content.instantiate()
	content.app_window = self
	content_root.add_child(content)

func set_focus(is_focused: bool) -> void:
	if content is TypingLevel:
		content.set_focus(is_focused)
		
	if is_focused:
		title_bar.remove_theme_stylebox_override("panel")
		title.remove_theme_color_override("font_color")
	else:
		title_bar.add_theme_stylebox_override("panel", get_theme_stylebox("unfocused", "TitleBar"))
		title.add_theme_color_override("font_color", get_theme_color("font_unfocused", "TitleBar"))

func _on_close_pressed() -> void:
	AudioManager.play_sfx(AudioManager.Sfx.mouse_click)
	hide()
	if _can_close:
		window_closed.emit(self)
	else:
		window_minimized.emit(self)

func _on_maximize_pressed() -> void:
	AudioManager.play_sfx(AudioManager.Sfx.mouse_click)
	focus_requested.emit(self)
	toggle_maximize()

func _on_minimize_pressed() -> void:
	AudioManager.play_sfx(AudioManager.Sfx.mouse_click)
	minimize()
