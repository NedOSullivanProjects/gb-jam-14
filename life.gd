extends HBoxContainer

@export var actor: CharacterBody2D
@export var healthIcon: PackedScene
var tempHealth : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tempHealth = actor.maxHealth
	for i in range(0,actor.maxHealth):
		var healthBar = healthIcon.instantiate()
		add_child(healthBar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_health_component_damage_taken(oldHealth: Variant, newHealth: Variant) -> void:
	if oldHealth <= 0:
		return
	var healthPaths = []
	var healthList := get_tree().get_nodes_in_group("HealthBar") # Creates a list of the nodes in group HealthBar
	#healthList.pop_back() #remove HealthComponant
	for i in range (0,len(healthList)):
		healthPaths.append(healthList[i].get_path()) #Turns those nodes into a list of paths to that node
	var healthToChange = oldHealth - newHealth
	for i in range (0, healthToChange):
		var Temp = get_node(healthPaths.pop_back()) #Gives temp the node path of the furthest right health icon
		Temp.queue_free() #Clears the node path stored in temp
	
	#comment of shame
	#tempHealth = actor.currentHealth # Without this line, the code failed to stop the player losing health forever, but with it, the player does not lose health anymore, unsure why
