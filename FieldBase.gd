class_name FieldBase

var state: Array
var old_state: Array
var size: Vector2i
var default_state: Variant


func _init(size_: Vector2i, default_state_: Variant):
	size = size_
	default_state = default_state_
	alloc_state()
	

func alloc_state() -> void:
	for i in range (size.x * size.y):
		old_state.append(default_state)
		state.append(default_state)


func pos_to_idx(x: int, y: int) -> int:
	return size.x * y + x

	
func get_cell_state(x: int, y: int, t: int=0) -> Variant:
	var i: int = pos_to_idx(x, y)
	return old_state[i] if t == 0 else state[i]


func set_cell_state(
	x: int, y: int, t: int=0, s: Variant=default_state) -> void:

	var i: int = pos_to_idx(x, y)
	if t == 0:
		old_state[i] = s
	else:
		state[i] = s
		

func push_state() -> void:
	for i in range(size.x * size.y):
		old_state[i] = state[i]


func reset() -> void:
	for i in range(size.x * size.y):
		old_state[i] = default_state
		state[i] = default_state


func _eval():
	assert(false, "Not implemented method")
