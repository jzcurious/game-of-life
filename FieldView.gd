extends TileMap

"""
	TODO:
		* Add zoom
		* Add saving
		* Detect pattern
		* Refact _input(event)
		* Add music
"""

const CELL_SIZE = Vector2(8, 8)

var screen_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
var field_size: Vector2i = screen_size / CELL_SIZE

var Field = load("res://FieldModel.gd")
var field = null
var field_map = null

var playing = false
var input_alive = false
var input_dead = false

var color_scheme = {
	Field.CELL_STATE.DEAD: Vector2i(1, 0),
	Field.CELL_STATE.ALIVE: Vector2i(0, 1),
	"static": Vector2i(2, 0),
}


# Called when the node enters the scene tree for the first time.
func _ready():	
	field = Field.new(field_size)
	field_map = get_parent().get_node("FieldMap")
	field_map.tile_set.tile_size = CELL_SIZE
	setting_up_camera()
	reset()
	

func reset():
	field.reset()
	for y in range(field.size.y):
		for x in range(field.size.x):
			set_cell(
				0, Vector2i(x, y), 0, color_scheme[field.CELL_STATE.DEAD]
			)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if !playing:
		return
		
	var old_field_state = field.copy_cell_state()
	
	field.update()
	
	for y in range(field.size.y):
		for x in range(field.size.x):
			var s_ = field.get_cell_state(x, y)
			var s = old_field_state[y][x]
			if s_ == s and s_ != field.CELL_STATE.DEAD:
				set_cell(0, Vector2i(x, y), 0, color_scheme["static"])
			else:
				set_cell(0, Vector2i(x, y), 0, color_scheme[s_])


func input_cell_state(s):
	var mouse_pos = get_local_mouse_position()

	mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - 1)
	mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - 1)
#
	var cell_position: Vector2i = (
		mouse_pos / CELL_SIZE
	).floor()
	
	field.set_cell_state(cell_position.x, cell_position.y, s)
	set_cell(0, cell_position, 0, color_scheme[s])


func _input(event):
	if event.is_action_pressed("toggle_play"):
		playing = !playing
		return
		
	if event.is_action_pressed("backspace"):
		playing = false
		reset()
		return

	if playing:
		input_alive = false
		input_dead = false

	if !input_dead and event.is_action_pressed("mouse_left_click"):
		if playing:
			playing = false
		input_alive = !input_alive
		
	if !input_alive and event.is_action_pressed("mouse_right_click"):
		if playing:
			playing = false
		input_dead = !input_dead
	
	if input_alive:
		input_cell_state(field.CELL_STATE.ALIVE)
		
	if input_dead:
		input_cell_state(field.CELL_STATE.DEAD)


func setting_up_camera():
	$Camera2D.position = screen_size / 2
