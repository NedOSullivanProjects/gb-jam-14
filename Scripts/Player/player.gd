extends CharacterBody2D

@export var maxHealth = 5
@export var currentHealth = maxHealth
const SPEED = 100.0
const JUMP_VELOCITY = -250.0#Temp values should be changed
var lastXVelocity = 0

var maxJumps = 1
var jumpsedUsed = 0
var direction = 1
var onHitboxDamage = false

signal spikes #used to signal player has taken damage from spikes

var recently_hit = false #this will be used to give the player invulnerability frames

signal onFloor




func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	if is_on_floor() and jumpsedUsed != 0:
		end_jump_animation()
		jumpsedUsed = 0

		
	# Handle jump.
	if Input.is_action_just_pressed("A Button") and is_on_floor(): #and not got double jump power
		jumpsedUsed += 1
		print(jumpsedUsed)
		velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("Left D-Pad", "Right D-Pad")
		if direction:
			lastXVelocity = direction * SPEED
			velocity.x = lastXVelocity
			#print(velocity.x)
		else:
			lastXVelocity = 0
			
	if jumpsedUsed > 0:
		jump_animation()
		velocity.x = lastXVelocity

	
	#print(velocity.x)
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
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
			$AnimatedSprite2D.flip_h = velocity.x > 0
		else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.animation = "still"
			velocity.x = 0
	
	move_and_slide()

		#Is move_and_slide correct?


#Triggers when the player hits spikes, could be used for all 
func _on_standing_hitbox_body_entered(body: Node2D) -> void:
	onHitboxDamage = true
	#if !recently_hit: #if player is not invulnerable, emits that they have been damaged
		#spikes.emit()
		#recently_hit = true
		#$InvulnTimer.start()
		#$FlashingTimer/PauseTimer.start()
		#hide()
	#elif recently_hit: #if the player is currently invulnerable, skips function
		#
		#pass

func _process(delta:float) -> void:
	if onHitboxDamage:
		$StandingHitbox/CollisionShape2D.set_deferred("disabled",true) #Disables collision till the end of the frame (Not the reason why the lives were being instantly lost
		if !recently_hit: #if player is not invulnerable, emits that they have been damaged
			jump_animation()
			ouch($AnimatedSprite2D.flip_h)
			spikes.emit()
			print("hit!")
			$HealthComponent.TakeDamage(1) # on second instance of damage, HealthComponent is no longer there?? Something like that, perhaps my code is somehow deleting healthcomponent in life.gd????
			recently_hit = true
			$FmodEventEmitter2D.play_one_shot()
			$InvulnTimer.start()
			$FlashingTimer/PauseTimer.start()
			hide()
			move_and_slide()
			await onFloor
			end_jump_animation()
		elif recently_hit: #if the player is currently invulnerable, skips function
			
			pass
	if is_on_floor():
		onFloor.emit()
	

func _on_invuln_timer_timeout() -> void: #Stops invulnerability animation from playing and makes player vulnerable again
	recently_hit = false
	$FlashingTimer.stop()
	$FlashingTimer/PauseTimer.stop()
	$StandingHitbox/CollisionShape2D.disabled = false
	show()


func _on_flashing_timer_timeout() -> void: # Flashing and pause both trigger off each other to make the players animation flash without pausing its movement animations
	hide()
	$FlashingTimer/PauseTimer.start()


func _on_pause_timer_timeout() -> void:
	show()
	$FlashingTimer.start()


func _on_standing_hitbox_body_exited(body: Node2D) -> void:
	onHitboxDamage = false

func jump_animation() -> void:
	$AnimatedSprite2D.animation = "crouch"
	$AnimatedSprite2D.offset.y = -5

func end_jump_animation() -> void:
	$AnimatedSprite2D.offset.y = 0

func ouch(directionFacing:bool) -> void:
	print("direction is " + str(directionFacing))
	if directionFacing:
		velocity.y = JUMP_VELOCITY
		velocity.x = -SPEED
		print(velocity.x)
	else:
		velocity.y = JUMP_VELOCITY
		velocity.x = SPEED
		print(velocity.x)



func _on_health_component_damage_taken(oldHealth: Variant, newHealth: Variant) -> void:
	currentHealth = newHealth
