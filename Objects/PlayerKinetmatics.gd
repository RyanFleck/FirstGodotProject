extends KinematicBody2D

const speed = 120
const grav = 40
const jump = 600

var velocity = Vector2()
var floor_normal = Vector2(0,-1)

func _process(delta):
	var animation
	
	if( !is_on_floor() ):
		if( velocity.y > 0 ):
			animation = "jump"
		else:
			animation = "fall"
	else:
		if( velocity.x == 0 ):
			animation = "idle"
		else:
			animation = "run"
	
	$AnimatedSprite.play(animation)
	pass

func get_input():
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	
	if( left and right ):
		velocity.x = 0
	elif( !left and !right ):
		velocity.x = 0
		
	elif( left ):
		velocity.x = -1 * speed
		$AnimatedSprite.flip_h = true
	elif( right ):
		velocity.x = 1 * speed
		$AnimatedSprite.flip_h = false
	
	if Input.is_action_pressed('ui_up') and is_on_floor():
	    velocity.y = -jump
	
	velocity.y += grav
	

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, floor_normal)
