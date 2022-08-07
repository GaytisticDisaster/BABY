extends KinematicBody2D


export (int) var speed = 250
var velocity = Vector2.ZERO

var eye_closed = false

onready var eyes = $eyes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement_input()
	move_and_slide(velocity)
	blink_input()
	
	
func movement_input():
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
			
	velocity = velocity.normalized() * speed

func blink_input():
	
	var left_eye = eyes.get_node("left")
	var right_eye = eyes.get_node("right")
	#var left_light = left_eye.get_node("light")
	
	if Input.is_action_pressed("blink"):
		eye_closed = true
		
		
	else:
		eye_closed = false
		
	left_eye.visible = !eye_closed
	right_eye.visible = !eye_closed
