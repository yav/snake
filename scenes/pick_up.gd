extends Area2D




func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	body.addFragment()
