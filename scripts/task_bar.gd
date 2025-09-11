extends Control
class_name TaskBar

@export var task_bar_button_contanier: Container
var task_bar_button_scene: PackedScene = preload("res://scenes/task_bar_button.tscn")

func on_app_window_spawned(app_window: AppWindow):
	var taskbar_button: TaskBarButton = task_bar_button_scene.instantiate()
	taskbar_button.task_name = app_window.title.text
	taskbar_button.task_icon = app_window.icon.texture
	taskbar_button.pressed.connect(_on_taskbar_button_pressed.bind(app_window, taskbar_button))
	task_bar_button_contanier.add_child(taskbar_button)
	app_window.set_meta("taskbar_button", taskbar_button)

func on_app_window_closed(app_window: AppWindow):
	var taskbar_button: TaskBarButton = app_window.get_meta("taskbar_button")
	taskbar_button.free()

func on_app_window_focused(app_window: AppWindow):
	for child: TaskBarButton in task_bar_button_contanier.get_children():
		child.set_focus(false)
	var taskbar_button: TaskBarButton = app_window.get_meta("taskbar_button")
	taskbar_button.set_focus(true)

func on_app_window_minimized(app_window: AppWindow):
	var taskbar_button: TaskBarButton = app_window.get_meta("taskbar_button")
	taskbar_button.set_focus(false)

func on_app_window_restored(app_window: AppWindow):
	var taskbar_button: TaskBarButton = app_window.get_meta("taskbar_button")
	taskbar_button.set_focus(true)

func _on_taskbar_button_pressed(app_window: AppWindow, taskbar_button: TaskBarButton):
	if taskbar_button.button_pressed:
#		Set taskbar button stuff here
		app_window.restore()
	else:
		app_window.minimize()
