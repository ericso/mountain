extends Label

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var corrected_y = get_viewport().get_visible_rect().size.y - mouse_pos.y
	position = mouse_pos + Vector2(10, 10)
	text = "Mouse: (%d, %d)" % [mouse_pos.x, corrected_y]
