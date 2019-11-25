extends Area2D

signal clicked

enum NATIONS {AUSTRIA, ENGLAND, FRANCE, GERMANY, ITALY, RUSSIA, TURKEY}
enum TYPES {ARMY, FLEET}
enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}

var active = false setget set_active
var nation = NATIONS.ENGLAND setget set_nation
var type = TYPES.ARMY setget set_type
var textures = {TYPES.ARMY: Rect2(144, 132, 33, 56),
				TYPES.FLEET: Rect2(907, 134, 42, 53)}
var move = null setget set_move
var target = null setget set_target
var start_position = null
var drag_position = null

func _ready():
	modulate = Color(1, 1, 1)

func set_move(_move):
	move = _move
	update()

func set_target(_target):
	target = _target
	update()
	
func set_nation(_nation):
	nation = _nation
	if !Engine.editor_hint:
		yield(self, 'tree_entered')
	$Sprite.modulate = CONSTANTS.COLORS[nation]
	
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
		modulate = Color(3, 3, 3)
	else:
		modulate = Color(1, 1, 1)
		#$Sprite.material.set_shader_param("outline_width", 0.0)
			
func _on_Piece_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			self.active = !self.active
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				self.move = MOVES.NONE
				var mpos = get_global_mouse_position()
				drag_position = mpos - global_position
			else:
				drag_position = null

func _unhandled_input(event):
	if event is InputEventMouseMotion and drag_position:
		position = get_global_mouse_position() - drag_position
			
		
func _draw():
	match move:
		MOVES.HOLD:
			var r = Vector2(25, 0)
			var points = PoolVector2Array()
			for a in range(7):
				points.append(r.rotated(a * 2*PI/6))
			var color = CONSTANTS.COLORS[nation].darkened(0.4)
			draw_polyline(points, color, 4.0, true)
		MOVES.MOVE:
			if target:
				var dest = target - global_position
				var color = CONSTANTS.COLORS[nation].darkened(0.4)
				draw_arrow(Vector2() + dest.normalized() * 10, dest, 10, color)
		MOVES.SUPPORT:
			if target:
				var dest = target - global_position
				var color = CONSTANTS.COLORS[nation].darkened(0.4)
				draw_arrow_dashed(Vector2() + dest.normalized() * 10, dest, 8, color)
		MOVES.CONVOY:
			if target:
				var dest = target - global_position
				var color = CONSTANTS.COLORS[nation].darkened(0.4)
				draw_arrow_dashed(Vector2() + dest.normalized() * 10, dest, 8, color)
					
func draw_arrow(start, end, size, color):
	var dir = (end - start).normalized()
	draw_polyline(PoolVector2Array([start, end-dir*size/2]), color, size, true)
	var a = end + dir * size/2 
	var b = end + dir.rotated(2*PI/3) * size
	var c = end + dir.rotated(4*PI/3) * size
	draw_polygon(PoolVector2Array([a, b, c]), PoolColorArray([color]))

func draw_arrow_dashed(start, end, size, color):
	# draw dashed line
	var dir = (end - start).normalized()
	var dist = (end - start).length()
	var dash = dir * dist / 10
	var gap = dir * dist / 20
	var n = 0
	var pos = start
	var points = PoolVector2Array()
	while n < dist:
		draw_polyline(PoolVector2Array([pos, pos + dash]), color, size, true)
		pos += dash + gap
		n += dash.length() + gap.length()
	# draw arrow end
	var a = end + dir * size/1.5 
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