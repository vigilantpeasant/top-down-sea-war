extends Line2D

var length : int = 10
var point = Vector2()

func _process(_delta):
	# Follow the parent's global position
	point = get_parent().global_position
	add_point(point)
	
	# Limit the trail length
	while get_point_count() > length:
		remove_point(0)
