extends KinematicBody2D


export (int) var speed = 250
var velocity = Vector2.ZERO

var eye_closed = false
var eye_closed_signal = false
var eye_closed_override = false

var is_idle = false
var full_idle = false

var animation_str = "Sit"
var dir = 1


onready var eyes = $eyes
onready var baby = $Sprite

onready	var idle_timer = $IdleTimer
onready var _animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement_input()
	move_and_slide(velocity)
	blink_input()
	eye_control()

func go_idle():
	print("IDLE\n")
	_animation_player.play("Idle")
	full_idle = true
	
	
func movement_input():
	"""
	Handles all movement related input.
	"""
	velocity = Vector2.ZERO

	
	# Changes velocity based on movement
	if Input.is_action_pressed("right"):
		velocity.x += 1
		dir = 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		dir = -1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	# Based on the new, input based velocity,
	# select the appropriate animation
	select_velocity_based_animation()
				
	if eye_closed:
		animation_str = animation_str + "_Closed"	
	else:
		animation_str.trim_suffix("_Closed")
	
	#print(animation_str)
	if animation_str and !full_idle:
		_animation_player.play(animation_str)

	velocity = velocity.normalized() * speed
	

func select_velocity_based_animation():
	"""
	Selects $BABY's animation based on the current velocity.
	This is what 
	"""
	if velocity == Vector2(0,0):
		#IDLE -> start idle timer
		animation_str = "Sit"
		
		if dir == 1:
			baby.flip_h = true
		else:
			baby.flip_h = false
			
		# If $BABY is not moving then start the idle timer
		# When the timer is done then $BABY will enter 
		# the idle animation
		if !is_idle:
			idle_timer.start()
			_animation_player.stop(false)
			
		is_idle = true
	else:
		baby.flip_h = false
		
		is_idle = false
		idle_timer.stop()
		
		if full_idle:
			full_idle = false
			open_eyes()
	# Right
	if velocity == Vector2(1,0):
		animation_str = "W_Right"
		
	# Left	
	if velocity == Vector2(-1,0):
		animation_str = "W_Left"
		
	# Down		
	if velocity == Vector2(0,1):
		animation_str = "W_Down"
		
	# Up
	if velocity == Vector2(0,-1):
		animation_str = "W_Up"
		
	# Down_Right
	if velocity == Vector2(1,1):
		animation_str = "W_Down_Right"
	
	# Up_Right
	if velocity == Vector2(1,-1):
		animation_str = "W_Up_Right"
		
	# Down_Left
	if velocity == Vector2(-1,1):
		animation_str = "W_Down_Left"
		
	# Up_Left
	if velocity == Vector2(-1,-1):
		animation_str = "W_Up_Left"


func close_eyes():
	eye_closed_override = true
	#eye_closed = true

func open_eyes():
	eye_closed_override = false

func blink_input():
	if Input.is_action_pressed("blink"):
		#eye_closed_signal = true
		eye_closed = true
	else:
		#eye_closed_signal = false
		eye_closed = false
		
func eye_control():
	if eye_closed_override:
		eye_closed = true
	
	eyes.energy = !eye_closed
