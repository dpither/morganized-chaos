class_name WindowManager
extends Control

@export var taskbar: TaskBar
@export var background: TextureRect
var app_windows: Array[AppWindow] = []
var active_window: AppWindow

func _ready() -> void:
	GameState.game_over.connect(open_window.bind("game_over"))
	background.gui_input.connect(_on_background_gui_input)
	await get_tree().process_frame
	open_window("level_select")

func open_window(app_id: String) -> void:
	# If window exists just focus it
	for app_window in app_windows:
		if app_window.get_app_id() == app_id:
			call_deferred("_focus_window", app_window)
			taskbar.on_app_window_spawned(app_window)
			return
	
	var app_window := AppFactory.get_app_window(app_id)
	app_window.window_manager = self
	var pos_x := randf_range(0, size.x - app_window.size.x)
	var pos_y := randf_range(0, size.y - app_window.size.y)
	app_window.global_position = Vector2(pos_x, pos_y)
	_connect_window_signals(app_window)
	app_windows.append(app_window)
	taskbar.on_app_window_spawned(app_window)
	add_child(app_window)
	call_deferred("_focus_window", app_window)

func _on_app_window_closed(app_window: AppWindow) -> void:
	taskbar.on_app_window_closed(app_window)

func _on_app_window_minimized(app_window: AppWindow) -> void:
	taskbar.on_app_window_minimized(app_window)

func _on_app_window_focused(app_window: AppWindow) -> void:
	_focus_window(app_window)

func _connect_window_signals(app_window: AppWindow) -> void:
	app_window.window_closed.connect(_on_app_window_closed)
	app_window.focus_requested.connect(_on_app_window_focused)
	app_window.window_minimized.connect(_on_app_window_minimized)

func _focus_window(app_window: AppWindow) -> void:
	active_window = app_window
	app_window.show()
	taskbar.on_app_window_focused(app_window)

	for child: AppWindow in get_children():
		child.set_focus(child == app_window)

	move_child(app_window, get_child_count() - 1)

func _on_background_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return

	if not event.pressed:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
		active_window.set_focus(false)
		taskbar.on_app_window_minimized(active_window)
