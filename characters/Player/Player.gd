extends KinematicBody2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

const max_horizontal_speed = 100
const fricWeight = 0.25
const max_falling_speed = 100

var inputVec = Vector2.ZERO
var momentum = Vector2.ZERO
var acceleration = 100
var jumpForce = 128
var gravity = 100

func _physics_process(delta): #Checks every frame for player movement
	inputVec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	momentum.x += inputVec.x * delta * acceleration
	momentum.x = clamp(momentum.x, -max_horizontal_speed, max_horizontal_speed ) #Caps horizontal speed
	print(momentum)
	
	#Changes sprite position based on direction
	if inputVec.x== -1:
		sprite.flip_h = true
	elif inputVec.x == 1:
		sprite.flip_h = false
		
	#Friction code
	if inputVec.x == 0:
		momentum.x = lerp(momentum.x, 0, fricWeight)
	if abs(momentum.x) < 0.1:
		momentum.x = 0
		print(momentum)
	
	momentum = move_and_slide(momentum, Vector2.UP)
#Sets gravity 
	momentum.y += gravity * delta
	momentum.y = clamp(momentum.y, momentum.y, max_falling_speed)
	print(momentum.y)
#Sets Jumping
	if Input.is_action_just_pressed("ui_select") && is_on_floor():
		momentum.y = -jumpForce
	#Update Animations
	var animation = "Idle"
	if abs (inputVec.x) > 0 && is_on_floor():
		animation = "Walk"
	if momentum.y < 0 && !is_on_floor():
		animation = "Jump"
	animation_player.play(animation)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
