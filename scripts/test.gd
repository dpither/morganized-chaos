extends ScrollContainer

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("clicked scroll")

func _ready() -> void:
	var scrollbar := get_v_scroll_bar()
	scrollbar.mouse_filter = Control.MOUSE_FILTER_PASS
	scrollbar.gui_input.connect(_on_scrollbar_gui_input)

func _on_scrollbar_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var scrollbar := get_v_scroll_bar()
			print(scrollbar.mouse_filter)
			print("clicked scrollbar")
