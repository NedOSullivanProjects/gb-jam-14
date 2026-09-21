extends CharacterBody2D

@export var targetNode : Node2D

@export var maxHealth : int

const SPEED = 20.0
const JUMP_VELOCITY = -200.0

func _ready()-> void:
	$Pathfinding.setTargetNode(targetNode)
	
	
var direction: Vector2 = Vector2(0,0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	show()
	direction = $Pathfinding.simpleFindPath(self.global_position)
	$AnimatedSprite2D.flip_h = direction.x > 0
	$AnimatedSprite2D.play()





func _on_hitbox_area_entered(area: Area2D) -> void:
	print("zombie hit")
	self.queue_free()
