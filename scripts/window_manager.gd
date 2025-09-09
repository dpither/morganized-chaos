extends Control
class_name WindowManager

@export var taskbar: TaskBar

var app_windows: Array[AppWindow] = []
var test = preload("res://scenes/AppWindow.tscn")

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	spawn_app_window(test, "test1")
	spawn_app_window(test, "test2")

func spawn_app_window(app_scene: PackedScene, title: String) -> AppWindow:
	var app_window:AppWindow = app_scene.instantiate()
	app_window.set_title(title)
	add_child(app_window)
	app_windows.append(app_window)
	app_window.connect("request_close", _on_app_window_closed)
	app_window.connect("request_focus", _on_app_window_focused)
	app_window.connect("request_minimize", _on_app_window_minimized)
	app_window.connect("request_restore", _on_app_window_restored)
	taskbar.on_app_window_spawned(app_window)
	_focus_window(app_window)
	return app_window

func _on_app_window_closed(app_window: AppWindow):
	if app_window in app_windows:
		app_windows.erase(app_window)
	app_window.queue_free()
	taskbar.on_app_window_closed(app_window)

func _on_app_window_restored(app_window: AppWindow):
	taskbar.on_app_window_restored(app_window)

func _on_app_window_minimized(app_window: AppWindow):
	taskbar.on_app_window_minimized(app_window)

func _on_app_window_focused(app_window: AppWindow):
	_focus_window(app_window)

func _focus_window(app_window: AppWindow):
	taskbar.on_app_window_focused(app_window)
	for child: AppWindow in get_children():
		child.set_focus(child == app_window)
	move_child(app_window, get_child_count() - 1)
