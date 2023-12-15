extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100 # Velocidade padrão do scroll dos créditos
const speed_up_multiplier := 10.0
const title_color := Color.purple

var scroll_speed := base_speed
var speed_up := false 

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

# O primeiro item de cada lista sempre virá em roxo
# Essa cor pode ser mudada no "title_color"
var credits = [
	[
		"Amarelo Girassol"
	],[
		"Membros da Equipe",
		"Eduardo",
		"Rodrigo",
		"Pablo",
		"André",
		"João",
		"José",
		"Davi"
	],[
		"Ferramentas Utilizadas",
		"Godot Engine",
		"https://godotengine.org/license",
		"",
		"Arte criada com Aseprite",
		"https://www.aseprite.org/"
	]
]

func _process(delta):
	# Velocidade de rolamento dos créditos
	var scroll_speed = base_speed * delta
	
	if section_next:
		
		# Se o usuário estiver segurando a tecla pra baixo, o timer dos créditos
		# vai correr mais rápido
		if speed_up:
			section_timer += delta * speed_up_multiplier
		else:
			section_timer += delta
			
		# Quando acabar o timer da linha que está passando, o timer vai resetar
		# e uma outra linha dos créditos poderá ser gerada
		if section_timer >= section_time:
			section_timer -= section_time
			
			# Gerando a próxima linha, caso ainda haja linhas pra passar
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		# Verifica se o jogador está pressionanando a seta pra baixo, e acelera
		# o timer dos créditos
		if speed_up:
			line_timer += delta * speed_up_multiplier
		else:
			line_timer += delta
			
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	# Além de acelerar o timer dos créditos, também aumenta a velociade
	# quando o player estiver clicando com a seta pra baixo
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	# Mudando a posição das linhas constantemente, de acordo com a scroll_speed
	# para dar o efeito de créditos rolando/subindo
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		
		# Quando os créditos terminam, a cena fecha
		get_tree().quit()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true

# A função _unhandled_input aqui trata dos inputs do usuário
func _unhandled_input(event):
	
	# Ação que pula os créditos
	if event.is_action_pressed("ui_cancel"):
		finish()
		
	# Quando o usuário segurar a seta pra baixo, os créditos vão
	# passar mais rápido
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
		
	# Quando o usuário não segurar mais a seta pra baixo, a velocidade
	# dos créditos retorna ao padrão
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
