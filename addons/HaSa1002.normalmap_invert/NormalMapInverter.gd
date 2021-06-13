tool
extends EditorPlugin

var in_event_frame := false

var input_control := preload("res://addons/HaSa1002.normalmap_invert/InputControl.gd").new()

func _enter_tree():
	add_tool_menu_item("Invert Normalmap (Copy)", self, "_on_invert_normalmap_pressed", false)
	add_tool_menu_item("Invert Normalmap (Replace)", self, "_on_invert_normalmap_pressed", true)
	var strgT := InputEventKey.new()
	strgT.scancode = KEY_T
	strgT.control = true
	InputMap.add_action("__mattool")
	InputMap.action_add_event("__mattool", strgT)
	var n := InputEventKey.new()
	n.control = true
	n.scancode = KEY_N
	InputMap.add_action("__mattool_normalmap")
	InputMap.action_add_event("__mattool_normalmap", n)
	var i := InputEventKey.new()
	i.control = true
	i.scancode = KEY_I
	InputMap.add_action("__mattool_normalmap_replace")
	InputMap.action_add_event("__mattool_normalmap_replace", i)
	input_control.connect("key_event", self, "gui_input")
	get_editor_interface().get_base_control().add_child(input_control)


func _exit_tree():
	remove_tool_menu_item("Invert Normalmap (Copy)")
	remove_tool_menu_item("Invert Normalmap (Replace)")
	InputMap.erase_action("__mattool")
	InputMap.erase_action("__mattool_normalmap")
	InputMap.erase_action("__mattool_normalmap_replace")
	get_editor_interface().get_base_control().remove_child(input_control)


func _on_invert_normalmap_pressed(replace):
	var path := get_editor_interface().get_current_path()
	if path.get_extension() != "png":
		printerr("No valid file selected")
		return
	var img := Image.new()
	var file := File.new()
	file.open(path, File.READ)
	if img.load_png_from_buffer(file.get_buffer(file.get_len())):
		printerr("Couldn't load image")
		return
	file.close()
	print(img.get_size())
	img.lock()
	for x in img.get_size().x:
		for y in img.get_size().y:
			var color := img.get_pixel(x, y)
			color.g = 1 - color.g
			img.set_pixel(x, y, color)
	img.save_png(path.get_basename() + (".png" if replace else "_inv.png"))
	img.unlock()
	get_editor_interface().get_resource_filesystem().scan()


func gui_input(event) -> bool:
	if Input.is_action_just_pressed("__mattool"):
		in_event_frame = true
		get_editor_interface().get_viewport().get_tree().create_timer(2.0).connect("timeout", self, "_on_shortcut_timeout")
		return true
	if in_event_frame && Input.is_action_just_pressed("__mattool_normalmap"):
		in_event_frame = false
		_on_invert_normalmap_pressed(false)
		return true
	if in_event_frame && Input.is_action_just_pressed("__mattool_normalmap_replace"):
		in_event_frame = false
		_on_invert_normalmap_pressed(true)
		return true
	return false


func _on_shortcut_timeout():
	in_event_frame = false
