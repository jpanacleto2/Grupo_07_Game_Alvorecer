extends Node2D

const MusicaAmbiente = preload("res://Music and Sounds/Musica/Boss/WhereEaglesDare.tscn")
const MusicaMorte = preload("res://Music and Sounds/Musica/Morte/StairWayToHeaven.tscn")
var tocando = false
var musica

var numWolf = 0
var wolfs = Array()

var armadura = 0
var arma = 0
var equipado = false
var Check = Vector2(0,0)

onready var Ferromante
onready var Player
onready var Grey


func _process(delta):
	if !tocando:
		musica = MusicaAmbiente.instance()
		#add_child(musica)
		tocando = true

func stopMusic():
	musica.queue_free()
	musica = MusicaMorte.instance()
	add_child(musica)

func _on_Ferromante_segunda_fase():
	for i in range(0, wolfs.size(), 1):
		if wolfs[i] != null:
			wolfs[i].queue_free()
#	wolfs = null
#	wolfs = Array()
