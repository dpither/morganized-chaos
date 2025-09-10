extends Control
class_name TaskBar

@export var app_contanier: Container

func on_app_window_spawned(app_window: AppWindow):
	var taskbar_button: Button = Button.new()
	taskbar_button.theme_type_variation = "LabelButton"
	taskbar_button.toggle_mode = true
	taskbar_button.text = app_window.title.text
	taskbar_button.icon = app_window.icon.texture
	taskbar_button.pressed.connect(_on_taskbar_button_pressed.bind(app_window, taskbar_button))
	app_contanier.add_child(taskbar_button)
	app_window.set_meta("taskbar_button", taskbar_button)

func on_app_window_closed(app_window: AppWindow):
	var taskbar_button: Button = app_window.get_meta("taskbar_button")
	taskbar_button.free()

func on_app_window_focused(app_window: AppWindow):
	for child: Button in app_contanier.get_children():
		child.button_pressed = false
	var taskbar_button: Button = app_window.get_meta("taskbar_button")
	taskbar_button.button_pressed = true

func on_app_window_minimized(app_window: AppWindow):
	var taskbar_button: Button = app_window.get_meta("taskbar_button")
	taskbar_button.button_pressed = false

func on_app_window_restored(app_window: AppWindow):
	var taskbar_button: Button = app_window.get_meta("taskbar_button")
	taskbar_button.button_pressed = true

func _on_taskbar_button_pressed(app_window: AppWindow, taskbar_button: Button):
	if taskbar_button.button_pressed:
		app_window.restore()
	else:
		app_window.minimize()
