extends KinematicBody2D

const speed = 70
const grav = 40
const jump = 600

var facing_right = true

var velocity = Vector2()
var floor_normal = Vector2(0,-1)

const turn_timeout = 0.5
var time_since_last_turn = 0

const jump_timeout = 0.7
var current_jump_timeout = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("walk")
	velocity.x = speed
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func calculate_movement():
	if !is_on_floor():
		velocity.y += grav
	pass

func _physics_process(delta):
	
	time_since_last_turn += delta
	
	if current_jump_timeout > 0:
		current_jump_timeout -= delta
	
	if facing_right:
		velocity.x = speed
	else:
		velocity.x = -speed
	calculate_movement()
	velocity = move_and_slide(velocity, floor_normal)
	
	if is_on_wall():
		if time_since_last_turn < turn_timeout:
			jump()
		else:
			time_since_last_turn = 0
			facing_right = !facing_right
			$AnimatedSprite.flip_h = !facing_right
			
func jump():
	if current_jump_timeout <= 0:
		velocity.y = -jump
		current_jump_timeout = jump_timeout