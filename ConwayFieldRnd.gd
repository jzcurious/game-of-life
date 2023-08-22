extends FieldBase

class_name ConwayFieldRnd


enum CELL_STATE {DEAD = 0, ALIVE = 1, SUPERPOSED = 2}


func _init(size_: Vector2i, default_state_: Variant):
	super._init(size_, CELL_STATE.DEAD)
	randomize()
	

func reduce(x: int, y: int) -> CELL_STATE:
	var i: int = pos_to_idx(x, y)
	if old_state[i] == CELL_STATE.SUPERPOSED:
		old_state[i] = randi() % 2
	return old_state[i]


func get_neighbor_count(x: int, y: int) -> int:
	var counter: int = 0
	var x_: int
	var y_: int
	var s: CELL_STATE
	
	for i in range(y - 1, y + 2):
		y_ = i % size.y
		for j in range(x - 1, x + 2):
			x_ = j % size.x
			if y_ == y and x_ == x:
				continue
			s = get_cell_state(x_, y_, 0)
			if s == CELL_STATE.SUPERPOSED:
				s = reduce(x_, y_)	
			if s == CELL_STATE.ALIVE:
				counter += 1

	return counter


func _eval():
	var s: CELL_STATE
	
	for y in range(size.y):
		for x in range(size.x):
			set_cell_state(x, y, 1, CELL_STATE.DEAD)
			s = get_cell_state(x, y, 0)
			match get_neighbor_count(x, y):
				3:
					set_cell_state(x, y, 1, CELL_STATE.ALIVE)
				2:
					if s == CELL_STATE.ALIVE:
						set_cell_state(x, y, 1, CELL_STATE.ALIVE)
				0:
					if s == CELL_STATE.ALIVE:
						set_cell_state(x, y, 1, CELL_STATE.SUPERPOSED)
				_:
					pass

	push_state()
