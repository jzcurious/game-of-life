enum CELL_STATE {DEAD = 0, ALIVE = 1}

var size: Vector2i
var cell_state = null
var prev_cell_state = null


func make_cells():
	var cells = []
	
	for y in range(size.y):
		var line = []
		for x in range(size.x):
			line.append(CELL_STATE.DEAD)
		cells.append(line)
		
	return cells


func copy_cell_state(dst=null, src=null): 
	if dst == null:
		dst = make_cells()
		
	if src == null:
		src = self.cell_state
	
	for y in range(size.y):
		for x in range(size.x):
			dst[y][x] = src[y][x]

	return dst


func push_cell_state():
	copy_cell_state(prev_cell_state, cell_state)


func get_neighbor_count(x, y):
	var counter: int = 0

	for i in range(y - 1, y + 2):
		var y_ = i % size.y
		for j in range(x - 1, x + 2):
			var x_ = j % size.x
			if y_ == y and x_ == x:
				continue
			counter += prev_cell_state[y_][x_]

	return counter


func _init(size_):
	size.x = size_.x
	size.y = size_.y

	cell_state = make_cells()
	prev_cell_state = make_cells()


func reset():
	for y in range(size.y):
		for x in range(size.x):
			prev_cell_state[y][x] = CELL_STATE.DEAD


func update():
	for y in range(size.y):
		for x in range(size.x):
			cell_state[y][x] = CELL_STATE.DEAD
			match get_neighbor_count(x, y):
				3:
					cell_state[y][x] = CELL_STATE.ALIVE
				2:
					if prev_cell_state[y][x] == CELL_STATE.ALIVE:
						cell_state[y][x] = CELL_STATE.ALIVE
				_:
					pass

	push_cell_state()
	

func get_cell_state(x, y):
	return cell_state[y][x]
	

func set_cell_state(x, y, s):
	prev_cell_state[y][x] = s
