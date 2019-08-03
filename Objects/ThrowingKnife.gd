extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = 300
var rotation_speed = 10
var velocity = Vector2()
var rotationp = 0
var collision = false
const grav = 40

const fadetimetotal = 2
var fadetime = fadetimetotal

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	velocity.x = speed
	
func traveling_right(rightp):
	if(!rightp):
		velocity.x = -speed
		rotation_speed = -rotation_speed
		$Sprite.flip_h = true

func set_angle():
	pass

func _process(delta):
	if( collision ):
		fadetime -= delta
		$Sprite.self_modulate.a = fadetime/fadetimetotal
		
	if( fadetime < 0 ):
		queue_free()

func _physics_process(delta):

	if !collision:
		rotationp = rotationp + (rotation_speed * delta)
		set_rotation(rotationp)
		move_and_slide(velocity)

	else:
		velocity.x = 0
		velocity.y += grav
		velocity = move_and_slide(velocity)
	
	if(get_slide_count()!=0):
		collision = true
		set_rotation(0)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
