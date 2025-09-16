extends Control
class_name TaskBar

@export var task_bar_button_container: Container
@export var task_bar_button_scene: PackedScene

func on_app_window_spawned(app_window: AppWindow):
	var taskbar_button: TaskBarButton = task_bar_button_scene.instantiate()
	taskbar_button.text = app_window.title.text
	if app_window.icon:
		taskbar_button.icon = app_window.icon.texture
	taskbar_button.pressed.connect(_on_taskbar_button_pressed.bind(app_window, taskbar_button))
	task_bar_button_container.add_child(taskbar_button)
	app_window.set_meta("taskbar_button", taskbar_button)

func on_app_window_closed(app_window: AppWindow):
	var taskbar_button: TaskBarButton = app_window.get_meta("taskbar_button")
	taskbar_button.free()

func on_app_window_focused(app_window: AppWindow):
	for child: TaskBarButton in task_bar_button_container.get_children():
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
	AudioManager.play_sfx(AudioManager.Sfx.mouse_click)
	if taskbar_button.button_pressed:
#		Set taskbar button stuff here
		app_window.restore()
	else:
		app_window.minimize()
