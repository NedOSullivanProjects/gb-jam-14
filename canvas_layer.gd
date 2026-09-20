extends CanvasLayer

var collectibles: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collectibles = get_tree().get_nodes_in_group("pickups")
	$HUD/Bar/goldLabel.text = "gold: " + str(0) + "/" + str(collectibles.size())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_player_got_gold(amount:int) -> void:
	print("got here")
	print(str(collectibles.size()))
	$HUD/Bar/goldLabel.text = "gold: " + str(amount) + "/" + str(collectibles.size())
