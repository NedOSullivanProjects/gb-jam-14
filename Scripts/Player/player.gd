extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0#Temp values should be changed
var lastXVelocity = 0

signal spikes #used to signal player has taken damage from spikes

var recently_hit = false #this will be used to give the player invulnerability frames


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
			$AnimatedSprite2D.flip_h = lastXVelocity > 0
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
		$AnimatedSprite2D.animation = "walk"
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("Left D-Pad", "Right D-Pad")
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.flip_h = velocity.x > 0
			$AnimatedSprite2D.play()
		else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.stop()
			velocity.x = 0

	move_and_slide()
	#Is move_and_slide correct?


#Triggers when the player hits spikes, could be used for all 
func _on_standing_hitbox_body_entered(body: Node2D) -> void:
	if !recently_hit: #if player is not invulnerable, emits that they have been damaged
		spikes.emit()
		recently_hit = true
		$InvulnTimer.start()
		$FlashingTimer/PauseTimer.start()
		hide()
	elif recently_hit: #if the player is currently invulnerable, skips function
		
		pass

func _on_invuln_timer_timeout() -> void: #Stops invulnerability animation from playing and makes player vulnerable again
	recently_hit = false
	$FlashingTimer.stop()
	$FlashingTimer/PauseTimer.stop()
	show()


func _on_flashing_timer_timeout() -> void: # Flashing and pause both trigger off each other to make the players animation flash without pausing its movement animations
	hide()
	$FlashingTimer/PauseTimer.start()


func _on_pause_timer_timeout() -> void:
	show()
	$FlashingTimer.start()
