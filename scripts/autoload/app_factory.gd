extends Node

var apps: Array[AppData] = []

var app_window_scene: PackedScene = preload("res://scenes/components/app_window/app_window.tscn")

func _ready() -> void:
  _load_apps()
  for level in GameState.levels:
    apps.append(level)

func get_app_window(app_id: String) -> AppWindow:
  var app_data := _get_app_data(app_id)

  if not app_data:
    return null
  
  var app_window: AppWindow = app_window_scene.instantiate()
  app_window.set_app_data(app_data)

  return app_window

func _load_apps() -> void:
  var path = "res://resources/app_data"
  var directory = DirAccess.open(path)
  if not directory:
    return
  for file_name in directory.get_files():
    var app_data: AppData = load(path + "/" + file_name)
    apps.append(app_data)
  print_debug("Loaded " + path)

func _get_app_data(app_id: String) -> AppData:
  for app in apps:
    if app.id == app_id:
      return app
  push_warning("No app with id: " + app_id)
  return null
