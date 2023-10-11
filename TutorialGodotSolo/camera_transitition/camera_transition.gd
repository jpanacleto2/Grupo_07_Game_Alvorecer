extends Node
onready var camera2D = $PlayerCam
onready var timer = $Timer
onready var boss = $BossCam
onready var player = $YSort/KinematicBody2D/PlayerRemote

func _ready():
	pass
	


#func _on_Ferromante_segunda_fase():
	#boss.remote_path = player.get_path()
	#player.remote_path = "null"
	#timer.start(5)


#func _on_Timer_timeout():
	#transition_camera2D(BossCam, camera2D)
	#player.remote_path = player.get_path()
	#boss.remote_path = "null"
