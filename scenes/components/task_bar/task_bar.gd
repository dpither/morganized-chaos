class_name TaskBar
extends Control

@export var task_bar_button_container: Container
@export var task_bar_button_scene: PackedScene
@export var paused_menu_scene: PackedScene

# TODO: See if can just use app window signals?

func on_app_window_spawned(app_window: AppWindow) -> void:
	var task_bar_button: TaskBarButton
	if app_window.has_meta("task_bar_button"):
		task_bar_button = app_window.get_meta("task_bar_button")
		task_bar_button_container.add_child(task_bar_button)
		return
	# var task_bar_button: TaskBarButton = task_bar_button_scene.instantiate()
	task_bar_button = task_bar_button_scene.instantiate()
	task_bar_button.text = app_window.title.text
	if app_window.icon:
		task_bar_button.icon = app_window.icon.texture
	task_bar_button.pressed.connect(_on_taskbar_button_pressed.bind(app_window, task_bar_button))
	task_bar_button_container.add_child(task_bar_button)
	app_window.set_meta("task_bar_button", task_bar_button)

func on_app_window_closed(app_window: AppWindow) -> void:
	var task_bar_button: TaskBarButton = app_window.get_meta("task_bar_button")
	task_bar_button_container.remove_child(task_bar_button)

func on_app_window_focused(app_window: AppWindow) -> void:
	for child: TaskBarButton in task_bar_button_container.get_children():
		child.set_focus(false)
	var task_bar_button: TaskBarButton = app_window.get_meta("task_bar_button")
	task_bar_button.set_focus(true)

func on_app_window_minimized(app_window: AppWindow) -> void:
	var task_bar_button: TaskBarButton = app_window.get_meta("task_bar_button")
	task_bar_button.set_focus(false)

func on_app_window_restored(app_window: AppWindow) -> void:
	var task_bar_button: TaskBarButton = app_window.get_meta("task_bar_button")
	task_bar_button.set_focus(true)

func _on_taskbar_button_pressed(app_window: AppWindow, task_bar_button: TaskBarButton) -> void:
	if task_bar_button.button_pressed:
		app_window.restore()
	else:
		app_window.minimize()
