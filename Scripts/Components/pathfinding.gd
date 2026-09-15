extends Node2D

@export var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#finds direction to face without considering obstacles and jumps, doesn't normalise either
func simpleFindPath(currentPosition: Vector2, myTargetPosition = target.position) -> Vector2:
	#if the target position is to the left of the current position
	var xDirection = sign(myTargetPosition.x - currentPosition.x)
	var yDirection = sign(myTargetPosition.y - currentPosition.y)
	var vectorDirection:Vector2 = Vector2(xDirection, yDirection)
	return vectorDirection


func setTargetNode(nodeToTarget:Node2D):
	target = nodeToTarget
