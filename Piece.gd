tool
extends Area2D

signal clicked

enum NATIONS {AUSTRIA, ENGLAND, FRANCE, GERMANY, ITALY, RUSSIA, TURKEY}
var COLORS = {ENGLAND: Color8(28, 37, 200),
			  FRANCE: Color8(52, 190, 230),
			  GERMANY: Color8(247, 150, 24),
			  AUSTRIA: Color8(140, 83, 214),
			  ITALY: Color8(41, 175, 36),
			  RUSSIA: Color8(226, 36, 36),
			  TURKEY: Color8(234, 227, 32)}
enum TYPES {ARMY, FLEET}
enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}

var active = false setget set_active
export (NATIONS) var nation = ENGLAND setget set_nation
export (TYPES) var type = ARMY setget set_type
var textures = {ARMY: Rect2(147, 71, 26, 50),
				FLEET: Rect2(909, 74, 37, 46)}
var move = null setget set_move
var target = null setget set_target
var start_position = null
var drag_position = null

func _ready():
	modulate = Color(1, 1, 1)
	
#	var c = $Sprite.modulate
#	c.r /= 2
#	c.g /= 2
#	c.b /= 2
#	$Sprite.material.set_shader_param("outline_color", c)

func set_move(_move):
	move = _move
	update()

func set_target(_target):
	target = _target
	update()
	
func set_nation(_nation):
	#print("set nation to ", nation)
	nation = _nation
	if !Engine.editor_hint:
		yield(self, 'tree_entered')
	$Sprite.modulate = COLORS[nation]
	
func set_type(_type):
	type = _type
	if !Engine.editor_hint:
		yield(self, 'tree_entered')
	$Sprite.region_rect = textures[type]
	
func set_active(flag):
	active = flag
	emit_signal('clicked', self)
	if active:
		#$Sprite.material.set_shader_param("outline_width", 2.0)
		modulate = Color(2, 2, 3)
	else:
		modulate = Color(1, 1, 1)
		#$Sprite.material.set_shader_param("outline_width", 0.0)
			
func _on_Piece_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			self.active = !self.active
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var mpos = get_global_mouse_position()
				drag_position = mpos - global_position
			else:
				drag_position = null

func _unhandled_input(event):
	if event is InputEventMouseMotion and drag_position:
		position = get_global_mouse_position() - drag_position
			
		
func _draw():
	match move:
		HOLD:
			var r = Vector2(25, 0)
			var points = PoolVector2Array()
			for a in range(7):
				points.append(r.rotated(a * 2*PI/6))
			#draw_polygon(points, PoolColorArray([COLORS[nation]]))
			draw_polyline(points, COLORS[nation], 4.0, true)
		MOVE:
			if target:
				var dest = target - global_position
				var color = COLORS[nation]
				color.a -= 0.25
				draw_arrow(Vector2() + dest.normalized() * 10, dest, 10, color)
		SUPPORT:
			if target:
				var dest = target - global_position
				var color = COLORS[nation]
				color /= 1.5
				draw_arrow_outline(Vector2() + dest.normalized() * 10, dest, 10, color)
					
func draw_arrow(start, end, size, color):
	var dir = (end - start).normalized()
	draw_polyline(PoolVector2Array([start, end-dir*size/2]), color, size, true)
	var a = end + dir * size/2 
	var b = end + dir.rotated(2*PI/3) * size
	var c = end + dir.rotated(4*PI/3) * size
	draw_polygon(PoolVector2Array([a, b, c]), PoolColorArray([color]))

func draw_arrow_outline(start, end, size, color):
	var points = PoolVector2Array()
	var dir = (end - start).normalized()
	points.append(start - dir.tangent() * size/4)
	points.append(end - dir*size/2 - dir.tangent() * size/4)
	points.append(end + dir.rotated(2*PI/3) * size)
	points.append(end + dir * size/2)
	points.append(end + dir.rotated(4*PI/3) * size)
	points.append(end - dir*size/2 + dir.tangent() * size/4)
	points.append(start + dir.tangent() * size/4)
	points.append(start - dir.tangent() * size/4)
	#draw_polyline(points, color, 5.0, true)
	draw_polygon(points, PoolColorArray([color]))