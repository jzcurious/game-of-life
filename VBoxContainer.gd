extends VBoxContainer

var current_card: int = 0
var cards = null

# Called when the node enters the scene tree for the first time.
func _ready():
	cards = [
		$Info, $Rules, $Shortcuts
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_pressed():
		next_card()
		

func next_card():
	if current_card < len(cards) - 1:
		cards[current_card].queue_free()
		current_card += 1
		cards[current_card].visible = true
	else:
		get_tree().change_scene_to_file("res://world.tscn")
		get_tree().get_root().get_node("Desc").queue_free()
