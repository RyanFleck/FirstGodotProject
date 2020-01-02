extends KinematicBody2D

var start_position = Vector2()

const speed = 40
const grav = 40
const jump_force = 600

var player : KinematicBody2D

var edge_lock = false
var wall_lock = false
var player_lock = false

var facing_right = true

var velocity = Vector2()
var floor_normal = Vector2(0,-1)

var idle_state = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	start_position = get_position()
	$AnimatedSprite.play("walk")
	$RayCast2D.exclude_parent = true
	$RayCast2D_Forward.exclude_parent = true
	velocity.x = speed
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if !idle_state:
		modulate = Color(1,0.7,0.7)
	else:
		modulate = Color(1, 1, 1)


func _physics_process(delta):
	
	velocity.y += grav
	
	var sees_player = check_player_lock()
	
	if( sees_player and !player_lock ):
		player_lock = true
		idle_state = false
		print(name+" sees player.")

	
	var speedmod = 1
	if !is_on_floor() or !idle_state:
		speedmod *= 2
		

	if facing_right:
		velocity.x = speed * speedmod
	else:
		velocity.x = -speed * speedmod
	
	if !edge_lock and is_on_floor() and !$RayCast2D.is_colliding() :
		edge_lock = true
		persue_move()
		
	if !wall_lock and is_on_wall():
		wall_lock = true
		handle_collisions_v3()
		handle_collisions_v2()
		
	
	# Process locks.
	if edge_lock and is_on_floor() and $RayCast2D.is_colliding() and !is_on_wall():
		edge_lock = false
		
	if wall_lock and !is_on_wall():
		wall_lock= false
	
	if player_lock and !sees_player:
		player_lock = false
		
	
	velocity = move_and_slide(velocity, floor_normal)

func handle_collisions_v3():
	var oview = get_object_in_view()
	var colobjs = []
	for i in get_slide_count():
j		colobjs.append(get_slide_collision(i).collider.name)

	if oview:
		print(name+" collided with "+oview.name)
	else:
		print(name+" collided with")
	print(colobjs)
	
	if "Player" in colobjs:
		die()

func handle_collisions_v2():
	var moved = false
	var x = get_object_in_view()
	for i in get_slide_count():
		var col_obj = get_slide_collision(i).collider
		
		if !moved and x and col_obj and x == col_obj:
			#print(name + " collided with " + x.name)
			if x.name == "Player":
				die()
				moved = true
			elif x.name == "Terrain":
				persue_move()
				moved = true
			elif "Demon" in x.name:
				turn()
				moved = true
			
		if !moved and col_obj:
			if col_obj.name == "Player":
				die()
				moved = true
			if col_obj.name == "Terrain":
				turn()
				moved = true
			if "Demon" in col_obj.name:
				turn()
				moved = true
	
	if !moved:
		persue_move()




func persue_move():
	if player.global_position.y < global_position.y:
		jump()
	
	if player.global_position.x > global_position.x and !facing_right:
		turn()
	
	elif player.global_position.x < global_position.x and facing_right:
		turn()

		

func check_player_lock():
	if $RayCast2D_Forward.is_colliding():
		var obj : Object = $RayCast2D_Forward.get_collider()
		if obj.name == "Player":
			# Demon sees player.
			return true

func get_object_in_view():
	if $RayCast2D_Forward.is_colliding():
		var obj : Object = $RayCast2D_Forward.get_collider()
		return obj
	else:
		return null


func jump():
	if is_on_floor():
		velocity.y = -jump_force

func turn( right : bool = !facing_right ):
	facing_right = right
	
	$AnimatedSprite.flip_h = !right
	
	var mod = 1
	if(!right):
		mod = -1

	# Update raycast directions.
	$RayCast2D.position.x = abs($RayCast2D.position.x) * mod
	$RayCast2D_Forward.position.x = abs($RayCast2D_Forward.position.x) * mod
	$RayCast2D_Forward.cast_to.x = abs($RayCast2D_Forward.cast_to.x) * mod
	

func die():
	idle_state = true
	set_position(start_position)


#func handle_collisions():
#	var collision_count = get_slide_count()
#	if collision_count != 0:
#		for i in collision_count:
#			# Adding a type argument allows the editor to generate .predictions
#			var collision : KinematicCollision2D = get_slide_collision(i)
#			if( collision.collider != null ):
#				if( collision.collider.is_class("KinematicBody2D")):
#					#turn(facing_right) # All demons run the same way.
#					turn()
#				elif !wall_contact_decision and is_on_wall() and !("Foreground" in collision.collider.name):
#					wall_contact_decision = true
#					turn()

