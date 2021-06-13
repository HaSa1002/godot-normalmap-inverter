extends Control

signal key_event(event)

func _unhandled_key_input(event):
	emit_signal("key_event", event)
