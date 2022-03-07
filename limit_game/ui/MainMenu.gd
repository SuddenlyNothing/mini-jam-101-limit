extends Control

onready var t := $Tween
onready var credits := $Credits

var credits_showing := false


func _on_Settings_pressed() -> void:
	OptionsMenu.set_active(true)


func _on_Credits_pressed() -> void:
	if credits_showing:
		t.remove_all()
		t.interpolate_property(credits, "rect_position", null, Vector2(0, 200), 1,
				t.TRANS_BACK, t.EASE_OUT)
		t.start()
	else:
		t.remove_all()
		t.interpolate_property(credits, "rect_position", null, Vector2(0, 0), 0.7,
				t.TRANS_BACK, t.EASE_OUT)
		t.start()
	credits_showing = not credits_showing
