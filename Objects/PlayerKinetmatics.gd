extends KinematicBody2D

const speed = 100
const grav = 40
const jump = 600

var velocity = Vector2()

var floor_normal = Vector2(0,-1)

func get_input():
	var left = Input.is_action_pressed('ui_left')
	
	var right = Input.is_action_pressed('ui_right')
		
	if( left and right ):
		velocity.x = 0
	elif( !left and !right ):
		velocity.x = 0
	elif( left ):
		velocity.x = -1 * speed
	elif( right ):
		velocity.x = 1 * speed
	
	if Input.is_action_pressed('ui_up') and is_on_floor():
	    velocity.y = -jump
	
	velocity.y += grav
	

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, floor_normal)
