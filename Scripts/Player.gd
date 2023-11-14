extends KinematicBody2D

var input_type = "keys" # "point" or "keys"

var max_speed =  400 # Maximum speed of the player
var speed = max_speed # Current speed of the player
var acceleration = 1200 # with wich the speed approached max_speed
var move_direction = Vector2(0, 0) # input for the animation player
var moving = false # activate movemnet and reset speed to zero if we would still
var destination = Vector2() # where the mouse click happened
var movement = Vector2() # The movement that we will pushed to the engine
var anim_direction
var last_direction
var anim_mode
var animation

var spell = preload("res://Scenes/Spell.tscn")
var can_fire = true
var rate_of_fire = 0.4
var shooting = false

func _unhandled_input(event):
	if input_type == "point":
		if event.is_action_pressed("Click"):
			moving = true
			destination = get_global_mouse_position()
		
#	For touch screen
#	if event is InputEventScreenTouch and event.pressed == true: # Detect touch screen pressed
#		destination = event.position  # the position of the touch

func _ready():
	anim_direction = "S"
	last_direction = Vector2(0, 1)

func _process(delta):
	AnimationLoop()
	SkillLoop()
	
func _physics_process(delta):
	MovementLoop(delta)
	
func SkillLoop():
	if Input.is_action_pressed("ui_accept") and can_fire:
		can_fire = false
		shooting = true
		speed = 0
		
		var spell_instance = spell.instance()
		spell_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
		
		if input_type == "point":
			get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
			spell_instance.rotation = get_angle_to(get_global_mouse_position())
		else:
			get_node("TurnAxis").rotation = last_direction.angle()
			spell_instance.rotation = last_direction.angle()
			
		get_parent().add_child(spell_instance)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true
		shooting = false
		speed = max_speed
	
func MovementLoop(delta):
	if input_type == "point":
		if moving == false:
			speed = 0
		else:
			speed = max_speed
#			speed += acceleration * delta
#		if speed > max_speed:
#			speed = max_speed
		movement = position.direction_to(destination) * speed
		
		if position.distance_to(destination) > 5:
			# calculates the angle in degrees to the point clicked
			move_direction = rad2deg(destination.angle_to_point(position)) 
			movement = move_and_slide(movement)
		else:
			moving = false
			
	if input_type == "keys":
		move_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		move_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 
		
		var motion = move_direction.normalized() * speed
		move_and_slide(motion, Vector2(0, 0))
		
func AnimationLoop():	
	if shooting:
		anim_mode = "Idle"
	else:	
		if input_type == "point":
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
			if moving:
				anim_mode = "Walk"
			else:
				anim_mode = "Idle"
				
		if input_type == "keys":
			match move_direction:
				Vector2(-1, 0):
					anim_direction = "W"
				Vector2(1, 0):
					anim_direction = "E"
				Vector2(0, 1):
					anim_direction = "S"
				Vector2(0, -1):
					anim_direction = "N"
				Vector2(-1, -1):
					anim_direction = "NW"
				Vector2(-1, 1):
					anim_direction = "SW"
				Vector2(1, -1):
					anim_direction = "NE"
				Vector2(1, 1):
					anim_direction = "SE"
			if move_direction != Vector2(0, 0):
				last_direction = move_direction
				anim_mode = "Walk"
			else:
				anim_mode = "Idle"
			
	animation = anim_mode + "_" + anim_direction
	get_node("AnimationPlayer").play(animation)
	
