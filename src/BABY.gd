extends KinematicBody2D


export (int) var speed = 250
var velocity = Vector2.ZERO

var eye_closed = false

onready var eyes = $eyes
onready var baby = $Sprite

onready var _animation_player = $AnimationPlayer

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
	
	if velocity == Vector2(0,0):
		#IDLE -> start idle timer
		pass
	if velocity == Vector2(1,0):
		#Right
		_animation_player.play("W_Right")
		pass
	if velocity == Vector2(-1,0):
		#Left
		pass
	if velocity == Vector2(0,1):
		#Down
		pass
	if velocity == Vector2(0,-1):
		#Up
		pass
	if velocity == Vector2(1,1):
		#Down_Right
		pass
	if velocity == Vector2(1,-1):
		#Up_Right
		pass
	if velocity == Vector2(-1,1):
		#Down_Left
		pass
	if velocity == Vector2(-1,-1):
		#Down_Right
		pass
			
	
	
			
	velocity = velocity.normalized() * speed
	

func blink_input():
	
	
	if Input.is_action_pressed("blink"):
		eye_closed = true
		
	else:
		eye_closed = false
		
	eyes.enabled = !eye_closed
