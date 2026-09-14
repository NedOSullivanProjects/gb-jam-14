extends Node2D

@export var maxHealth : int

var currentHealth : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal died

signal damage_taken(oldHealth, newHealth)

signal healed(oldHealth, newHealth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func InitialiseHealth() -> void:
	currentHealth = maxHealth

func TakeDamage(changeBy: int) ->void:
	var oldHealth = currentHealth
	currentHealth -= changeBy
	damage_taken.emit(oldHealth, currentHealth)
	if currentHealth == 0:
		died.emit()
	
func HealDamage(changeBy: int) ->void:
	var oldHealth = currentHealth
	currentHealth += changeBy
	healed.emit(oldHealth, currentHealth)

func SetMaxHealth(health:int)-> void:
	maxHealth = health
	
func changeMaxHealth(changeBy:int)-> void:
	maxHealth += changeBy
