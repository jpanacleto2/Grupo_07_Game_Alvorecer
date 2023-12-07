extends KinematicBody2D

export var id = 10001
onready var sprite = $Sprite
var velocity = Vector2.ZERO
onready var main = get_tree().current_scene
var segue = false
var podePega = true
var player = null

func _ready():
	for i in PlayerData.inv_data.keys():
		#var inv_slot_new = template_inv_slot.instance()
			
			var item_name = GameData.item_data[str(id)]["Name"]
			var icon_texture = load("res://Inventario/SpritesItens/"+ item_name +".tres")
			sprite.texture = icon_texture
			
func _process(delta):
	if player != null:
		segue = true
	
	
	
	var dir = global_position.direction_to(main.Player.global_position)
	move_and_slide(velocity)
	
	if segue && podePega:
		velocity = velocity.move_toward(dir * 100, 100)
	
	
	if global_position.distance_to(main.Player.global_position) < 2 && podePega:
		for i in PlayerData.inv_data.keys():
			if PlayerData.inv_data[i]["Item"] == null && segue:
				PlayerData.inv_data[i]["Item"] = id
				segue = false
#				var f = File.new()
#				f.open("res://Json/inv_data_file.json", File.WRITE)
#				f.store_string(JSON.print(PlayerData.inv_data, "  "))
#				f.close()
				queue_free()



	
func expulso():
	var de = randi()%2+1
	segue = false
	podePega = false
	if de == 1:
		global_position = main.Player.global_position + Vector2(-50, -30)
		velocity.y = 75
	else:
		global_position = main.Player.global_position + Vector2(50, -30)
		velocity.y = 75
	yield(get_tree().create_timer(0.5), "timeout")
	velocity = Vector2.ZERO
	yield(get_tree().create_timer(0.3), "timeout")
	podePega = true

func _on_Area2D_body_entered(body):
	#print("Nio")
	player = body
	
	
