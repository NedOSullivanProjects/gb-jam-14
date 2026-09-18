extends HBoxContainer

@export var actor: CharacterBody2D
@export var healthIcon: PackedScene
var tempHealth : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tempHealth = actor.maxHealth
	print(actor.maxHealth)
	for i in range(0,actor.maxHealth):
		var healthBar = healthIcon.instantiate()
		add_child(healthBar)
		print (i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var healthPaths = []
	var healthList := get_tree().get_nodes_in_group("HealthBar") # Creates a list of the nodes in group HealthBar
	for i in range (0,len(healthList)):
		healthPaths.append(healthList[i].get_path()) #Turns those nodes into a list of paths to that node
		#print(len(healthList))
		#print(actor.currentHealth)
		#print(tempHealth) 
		#print("----") # Debugging print statements
	if actor.currentHealth < tempHealth: 
		var healthToChange = tempHealth - actor.currentHealth
		for i in range (0, healthToChange):
			var Temp = get_node(healthPaths[-1]) #Gives temp the node path of the furthest right health icon
			print(Temp)
			Temp.queue_free() #Clears the node path stored in temp
		tempHealth = actor.currentHealth # Without this line, the code failed to stop the player losing health forever, but with it, the player does not lose health anymore, unsure why
	else:
		pass
	
