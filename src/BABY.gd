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
	velocity = Vector2.ZERO

	print(idle_timer.time_left)
	
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
	
	if velocity == Vector2(0,0):
		#IDLE -> start idle timer
		animation_str = "Sit"
		
		if dir == 1:
			baby.flip_h = true
		else:
			baby.flip_h = false
			
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
	
	if velocity == Vector2(1,0):
		#Right
		animation_str = "W_Right"
	if velocity == Vector2(-1,0):
		#Left

		animation_str = "W_Left"
	if velocity == Vector2(0,1):
		#Down
		animation_str = "W_Down"
	if velocity == Vector2(0,-1):
		#Up
		animation_str = "W_Up"
	if velocity == Vector2(1,1):
		#Down_Right
		animation_str = "W_Down_Right"
	if velocity == Vector2(1,-1):
		#Up_Right
		animation_str = "W_Up_Right"
	if velocity == Vector2(-1,1):
		#Down_Left
		animation_str = "W_Down_Left"
	if velocity == Vector2(-1,-1):
		#Up_Left
		animation_str = "W_Up_Left"
			
	if eye_closed:
		animation_str = animation_str + "_Closed"	

	else:
		if "_Closed" in animation_str:
			animation_str.erase(animation_str.length() - 1, 7)
	
	#print(animation_str)
	if animation_str and !full_idle:
		_animation_player.play(animation_str)

	velocity = velocity.normalized() * speed
	

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
	
	eyes.enabled = !eye_closed
