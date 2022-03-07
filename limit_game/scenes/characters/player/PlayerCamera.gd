extends Camera2D

const LOOK_AHEAD_FACTOR = 0.05

var max_shake := 4
var facing = 0

onready var t := $Tween
onready var prev_camera_pos = get_camera_position()

func _process(_delta: float) -> void:
	_check_facing()
	prev_camera_pos = get_camera_position()

func _check_facing() -> void:
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 and facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		
		t.interpolate_property(self, "position:x", position.x, target_offset, 1.0,
			Tween.TRANS_SINE, Tween.EASE_OUT)
		t.start()


func update_grounded(is_grounded: bool) -> void:
	drag_margin_v_enabled = !is_grounded


func shake() -> void:
	for i in 4:
		offset = Vector2(randf() * max_shake * 2 - max_shake,
				randf() * max_shake * 2 - max_shake)
		yield(get_tree(), "idle_frame")
		offset = Vector2()
		yield(get_tree(), "idle_frame")
