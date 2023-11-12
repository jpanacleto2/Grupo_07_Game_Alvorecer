extends Node2D

var numWolf = 0
var wolfs = Array()
onready var Ferromante
onready var Player


func _physics_process(delta):
	#print(Ferromante)
	pass


func _on_Ferromante_segunda_fase():
	for i in range(0, wolfs.size(), 1):
		wolfs[i].queue_free()
	wolfs = null
	wolfs = Array()
