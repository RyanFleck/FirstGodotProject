extends KinematicBody2D

var start_position = Vector2()

const speed = 40
const grav = 40
const jump_force = 600

var edge_ray_decision = false
var wall_contact_decision = false

var facing_right = true

var velocity = Vector2()
var floor_normal = Vector2(0,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = get_position()
	$AnimatedSprite.play("walk")
	velocity.x = speed
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func calculate_movement():
	if !is_on_floor():
		velocity.y += grav

func _physics_process(delta):
	
	var speedmod = 1
	if !is_on_floor():
		speedmod = 2

	if facing_right:
		velocity.x = speed * speedmod
	else:
		velocity.x = -speed * speedmod
	calculate_movement()
	
	if !edge_ray_decision and !$RayCast2D.is_colliding():
		edge_ray_decision = true
		if(is_on_floor()):
			var x = randf()
			if x > 0.7:
				turn()
			elif x > 0.2:
				jump()

	if edge_ray_decision and $RayCast2D.is_colliding():
		edge_ray_decision = false
	
	handle_collisions()
	
	if wall_contact_decision and !is_on_wall():
		wall_contact_decision = false
	
	velocity = move_and_slide(velocity, floor_normal)


func jump():
	if is_on_floor():
		velocity.y = -jump_force

func turn( right : bool = !facing_right ):
	facing_right = right
	
	$AnimatedSprite.flip_h = !right
	
	var mod = 1
	if(!right):
		mod = -1

	$RayCast2D.position.x = abs($RayCast2D.position.x) * mod

func die():
	set_position(start_position)
	
func handle_collisions():
	var collision_count = get_slide_count()
	if collision_count != 0:
		for i in collision_count:
			# Adding a type argument allows the editor to generate .predictions
			var collision : KinematicCollision2D = get_slide_collision(i)
			if( collision.collider != null ):
				if( collision.collider.is_class("KinematicBody2D")):
					#turn(facing_right) # All demons run the same way.
					turn()
				elif !wall_contact_decision and is_on_wall():
					wall_contact_decision = true
					turn()
