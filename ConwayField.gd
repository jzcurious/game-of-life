extends FieldBase

class_name ConwayField


enum CELL_STATE {DEAD = 0, ALIVE = 1}


func _init(size_: Vector2i, default_state_: Variant):
	super._init(size_, CELL_STATE.DEAD)


func get_neighbor_count(x: int, y: int) -> int:
	var counter: int = 0
	var x_: int
	var y_: int
	
	for i in range(y - 1, y + 2):
		y_ = i % size.y
		for j in range(x - 1, x + 2):
			x_ = j % size.x
			if y_ == y and x_ == x:
				continue
			counter += get_cell_state(x_, y_, 0)

	return counter


func _eval():
	for y in range(size.y):
		for x in range(size.x):
			set_cell_state(x, y, 1, CELL_STATE.DEAD)
			match get_neighbor_count(x, y):
				3:
					set_cell_state(x, y, 1, CELL_STATE.ALIVE)
				2:
					if get_cell_state(x, y, 0) == CELL_STATE.ALIVE:
						set_cell_state(x, y, 1, CELL_STATE.ALIVE)
				_:
					pass

	push_state()
