extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0#Temp values should be changed
var lastXVelocity = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = lastXVelocity 
	# Handle jump.
	if Input.is_action_just_pressed("A Button") and is_on_floor(): #and not got double jump power
		velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("Left D-Pad", "Right D-Pad")
		if direction:
			lastXVelocity = direction * SPEED
		else:
			lastXVelocity = 0

	
	if Input.is_action_pressed("Up D-Pad") and Input.is_action_just_pressed("B Button"):
		#perform second selected attack
		pass
		
	elif Input.is_action_just_pressed("B Button"):
		#handle attacking
		pass
		
	if Input.is_action_just_pressed("Select"):
		#switch second weapon
		pass
	
	if Input.is_action_pressed("Down D-Pad"):
		#prevent movement and attacks should be different with different animation
		pass
	elif is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("Left D-Pad", "Right D-Pad")
		if direction:
			velocity.x = direction * SPEED
		else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.x = 0

	move_and_slide()
	#Is move_and_slide correct?
