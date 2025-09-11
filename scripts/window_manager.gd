extends Control
class_name WindowManager

@export var taskbar: TaskBar

var app_windows: Array[AppWindow] = []
var app_scene: PackedScene = preload("res://scenes/app_window.tscn")

var _level_select_scene: PackedScene = preload("res://scenes/level_select.tscn")
var _todo_icon: AtlasTexture = preload("res://assets/ui/todo_icon.tres")

func _ready() -> void:
	_spawn_level_select_window()
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
	spawn_app_window("test")
	#spawn_app_window("test2")

func spawn_app_window(title: String) -> AppWindow:
	var app_window:AppWindow = app_scene.instantiate()
	app_window.set_title(title)
	app_windows.append(app_window)
	_connect_window_signals(app_window)
	add_child(app_window)
	taskbar.on_app_window_spawned(app_window)
	_focus_window(app_window)
	return app_window

func _spawn_level_select_window() -> void:
	var level_select_window: AppWindow = app_scene.instantiate()
	level_select_window.set_title("TODO")
	level_select_window.set_icon(_todo_icon)
	level_select_window.can_close = false
	var level_select_content: LevelSelect = _level_select_scene.instantiate()
	level_select_content.app_window = level_select_window
	level_select_window.content = level_select_content
	_connect_window_signals(level_select_window)
	add_child(level_select_window)
	taskbar.on_app_window_spawned(level_select_window)
	_focus_window(level_select_window)
	

func _on_app_window_closed(app_window: AppWindow) -> void:
	if app_window in app_windows:
		app_windows.erase(app_window)
	app_window.queue_free()
	taskbar.on_app_window_closed(app_window)

#func _on_app_window_restored(app_window: AppWindow) -> void:
	#taskbar.on_app_window_restored(app_window)

func _on_app_window_minimized(app_window: AppWindow) -> void:
	taskbar.on_app_window_minimized(app_window)

func _on_app_window_focused(app_window: AppWindow) -> void:
	print("focusing" + app_window.title.text)
	_focus_window(app_window)

func _connect_window_signals(app_window: AppWindow) -> void:
	app_window.connect("request_close", _on_app_window_closed)
	app_window.connect("request_focus", _on_app_window_focused)
	app_window.connect("request_minimize", _on_app_window_minimized)
	#app_window.connect("request_restore", _on_app_window_restored)

func _focus_window(app_window: AppWindow) -> void:
	taskbar.on_app_window_focused(app_window)
	for child: AppWindow in get_children():
		child.set_focus(child == app_window)
	move_child(app_window, get_child_count() - 1)
