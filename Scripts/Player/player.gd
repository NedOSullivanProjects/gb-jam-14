extends CharacterBody2D

@export var maxHealth = 5
@export var currentHealth = maxHealth
var gold = 0
const SPEED = 50.0
const JUMP_VELOCITY = -250.0#Temp values should be changed
var lastXVelocity = 0
var isAttacking = false
var maxJumps = 1
var jumpsedUsed = 0
var direction = 1
var onHitboxDamage = false

signal changeFacingDirection(facingRight: bool)
signal spikes #used to signal player has taken damage from spikes

var recently_hit = false #this will be used to give the player invulnerability frames

signal onFloor


signal gotGold(amount:int)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	if is_on_floor() and jumpsedUsed != 0:
		end_jump_animation()
		jumpsedUsed = 0

		
	# Handle jump.
	if not isAttacking:
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

		if Input.is_action_just_pressed("B Button") and not is_on_floor():
			standAttack()
			pass
		#print(velocity.x)
		#if Input.is_action_pressed("Up D-Pad") and Input.is_action_just_pressed("B Button"):
			##perform second selected attack
			#pass
			
		elif Input.is_action_just_pressed("B Button") and Input.is_action_pressed("Down D-Pad") and is_on_floor():
			crouchAttack()
			
			
		elif Input.is_action_just_pressed("B Button") and is_on_floor():
			standAttack()
			
		#if Input.is_action_just_pressed("Select"):
			##switch second weapon
			#pass
		
		elif Input.is_action_pressed("Down D-Pad") and is_on_floor():
			velocity.x = 0
			$AnimatedSprite2D.animation = "crouch"
			$StandingHitbox/CollisionShape2D.disabled = true
			$CrouchingHitbox/CollisionShape2D.disabled = false
			
		elif is_on_floor():
			$StandingHitbox/CollisionShape2D.disabled = false
			$CrouchingHitbox/CollisionShape2D.disabled = true
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction := Input.get_axis("Left D-Pad", "Right D-Pad")
			if direction:
				velocity.x = direction * SPEED
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.flip_h = velocity.x > 0
				emit_signal("changeFacingDirection", $AnimatedSprite2D.flip_h)
			else:
				#velocity.x = move_toward(velocity.x, 0, SPEED)
				$AnimatedSprite2D.animation = "still"
				velocity.x = 0
		else:
			$StandingHitbox/CollisionShape2D.disabled = false
			$CrouchingHitbox/CollisionShape2D.disabled = true
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

func standAttack():
	isAttacking = true
	$StandAttackHitbox/CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	$StandAttackHitbox/CollisionShape2D.set_deferred("disabled",true)
	isAttacking = false

func crouchAttack():
	isAttacking = true
	$CrouchAttackHitbox/CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite2D.play("crouch attack")
	await $AnimatedSprite2D.animation_finished
	$CrouchAttackHitbox/CollisionShape2D.set_deferred("disabled",true)
	isAttacking= false

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



func _ready() -> void:
	$StandAttackHitbox/CollisionShape2D.set_deferred("disabled", true)
	$CrouchAttackHitbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "walk"
	isAttacking = false
	

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

func add_gold(amount: int):
	gold += amount
	#print("got here")
	gotGold.emit(gold)


func _on_crouching_hitbox_body_entered(body: Node2D) -> void:
	onHitboxDamage = true
