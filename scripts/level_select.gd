extends Control
class_name LevelSelect

@export var scroll_container: ScrollContainer
@export var app_window: AppWindow

func _ready() -> void:
	var scrollbar = scroll_container.get_v_scroll_bar()
	scrollbar.gui_input.connect(_on_scrollbar_gui_input)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			pass

func _on_scrollbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if app_window:
				app_window.emit_signal("request_focus", app_window)
