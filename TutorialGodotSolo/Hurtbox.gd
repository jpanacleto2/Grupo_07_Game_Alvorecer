extends Area2D
const HitEffect = preload ("res://Effects/Hit.tscn")

var invicible  = false setget set_invicible
var bria = monitoring

onready var timer = $Timer
signal invicibility_start
signal invicibility_end
var MopaEffect = preload("res://Effects/Hit.tscn")

func set_invicible(value):
	invicible = value
	if invicible == true:
		emit_signal("invicibility_start")
		
	else:
		emit_signal("invicibility_end")

func start_invicibility(duration):
	self.invicible = true
	timer.start(duration)
	
	

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

	
func _on_Timer_timeout():
	self.invicible = false



func _on_Hurtbox_invicibility_end():
	set_deferred("monitoring", true)
	



func _on_Hurtbox_invicibility_start():
	set_deferred("monitoring", false)
	
	

	
