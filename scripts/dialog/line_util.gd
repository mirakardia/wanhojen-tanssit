extends Line2D


func get_point_from_line(value: float) -> Vector2:
	if get_point_count() != 2:
		push_error("Line must have only 2 points")
		return Vector2(0,0)
	
	var pointA = get_point_position(0)
	var pointB = get_point_position(1)
	return pointA.lerp(pointB, value)