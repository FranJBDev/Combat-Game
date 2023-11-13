extends KinematicBody2D

var max_speed =  400 # Maximum speed of the player
var speed = 0 # Current speed of the player
var acceleration = 1200 # with wich the speed approached max_speed
var move_direction # input for the animation player
var moving = false # activate movemnet and reset speed to zero if we would still
var destination = Vector2() # where the mouse click happened
var movement = Vector2() # The movement that we will pushed to the engine

func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		moving = true
		destination = get_global_mouse_position()

func _process(delta):
	AnimationLoop()
	
func _physics_process(delta):
	MovementLoop(delta)
	
func MovementLoop(delta):
	if moving == false:
		speed = 0
	else:
		speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed
	movement = position.direction_to(destination) * speed
	
	print("grados ", move_direction)
	if position.distance_to(destination) > 5:
		# calculates the angle in degrees to the point clicked
		move_direction = rad2deg(destination.angle_to_point(position)) 
		movement = move_and_slide(movement)
	else:
		moving = false
	
func AnimationLoop():
	var anim_direction = "S"
	var anim_mode = "Idle"
	var animation
	if move_direction <= 15 and move_direction >= -15:
		anim_direction = "E"
	elif move_direction <= 60 and move_direction >= 15:
		anim_direction = "SE"
	elif move_direction <= 120 and move_direction >= 60:
		anim_direction = "S"
	elif move_direction <= 165 and move_direction >= 120:
		anim_direction = "SW"
	elif move_direction <=-120  and move_direction >= -165:
		anim_direction = "NW"
	elif move_direction <=-60  and move_direction >= -120:
		anim_direction = "N"
	elif move_direction <= -15 and move_direction >= -60:
		anim_direction = "NE"
	elif move_direction <= -165 or move_direction >= 165:
		anim_direction = "W"
		
	print(anim_direction)
	if moving:
		anim_mode = "Walk"
	else:
		anim_mode = "Idle"
	animation = anim_mode + "_" + anim_direction
	get_node("AnimationPlayer").play(animation)
	
