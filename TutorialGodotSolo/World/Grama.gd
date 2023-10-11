extends StaticBody2D

func grassEffect():
	var main = get_tree().current_scene
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	main.add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_hitbox_area_entered(area):
	grassEffect()
	queue_free()
