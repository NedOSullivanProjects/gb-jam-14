extends Area2D
var amount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("pickups")
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var PlayerNode = get_node("../../Player")#I hate this but too late to figure out how to rly do it
		PlayerNode.add_gold(amount)
		self.queue_free()
