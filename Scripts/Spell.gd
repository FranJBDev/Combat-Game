extends RigidBody2D

# To detect collision set RigidBody option contact report to 1 and contact monitor to true 

var projectil_speed = 600
var life_time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(), Vector2(projectil_speed, 0).rotated(rotation))
	self_destruct()
	
func self_destruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Spell_body_entered(body):
	self.hide()
