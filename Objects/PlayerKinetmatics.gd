extends KinematicBody2D

const KNIFE = preload("res://Objects/ThrowingKnife.tscn")

const speed = 120
const grav = 40
const jump = 600

var facing_right = true

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

func get_input_movement():
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	
	if( left and right ):
		velocity.x = 0
	elif( !left and !right ):
		velocity.x = 0
		
	elif( left ):
		velocity.x = -1 * speed
		$AnimatedSprite.flip_h = true
		facing_right = false
	elif( right ):
		velocity.x = 1 * speed
		$AnimatedSprite.flip_h = false
		facing_right = true
	
	if Input.is_action_just_pressed('ui_accept') and is_on_floor():
	    velocity.y = -jump
	
	velocity.y += grav

func get_input_actions():
	var action = Input.is_action_just_pressed('ui_attack')
	
	if(action):
		var knife = KNIFE.instance()
		# knife.speed += velocity.x
		get_parent().add_child(knife)
		knife.global_position = $KnifePoint.global_position
		if(!facing_right):
			knife.position.x -= $KnifePoint.position.x * 2
			knife.traveling_right(false)

		print("Player at "+str(global_position.x))
		print("Knife spawning at "+str($KnifePoint.global_position.x))

func _physics_process(delta):
	get_input_movement()
	get_input_actions()
	velocity = move_and_slide(velocity, floor_normal)
