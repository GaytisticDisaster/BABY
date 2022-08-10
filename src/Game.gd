extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var baby = $YSort/BABY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func findByClass(node: Node, className : String) -> Array:
	var result = []
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		result += findByClass(child, className)

	return result


const brightnessCoefficient = 1000_000
func getBrightness(p: Vector2) -> float:
	var brightness = 0
	
	var space_state = get_world_2d().direct_space_state
	
	# use global coordinates, not local to node
	for node in findByClass(self, "Light2D"):
		
		var hit_log = space_state.intersect_ray(p, node.position)
		# There is no obstruction
		if !hit_log:
			var distance2 = p.distance_squared_to(node.get_position())
			brightness += brightnessCoefficient* node.energy * 1 / distance2
		else:
			print_debug("Hit: %s" % hit_log)
			
	return brightness     


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print_debug("Baby Brightness: %s" % getBrightness(baby.position))
	pass
