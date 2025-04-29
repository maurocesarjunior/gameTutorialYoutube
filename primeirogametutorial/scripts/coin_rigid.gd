extends RigidBody2D

func _on_tree_exited() -> void:
	queue_free()
