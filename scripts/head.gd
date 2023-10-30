extends CharacterBody2D

var fragment = preload("res://scenes/fragment.tscn")
var speed = 150
var rot_speed = 2.5

var counter: int = 0
const delay: int = 25
var history = 0
var past_locations: Array[Vector2] = []
var past_rotations: Array[float] = []

func _ready():
	for _i in range(delay):
		past_locations.append(Vector2.ZERO)
		past_rotations.append(0)
	history = delay

func _process(_delta):
	if Input.is_action_just_released("spawn"):
		addFragment()
	if Input.is_action_pressed("up"):
		speed += 20
	if Input.is_action_pressed("down"):
		speed -= 20


func checkInput(delta):
	rotation += rot_speed * Input.get_axis("left","right") * delta
	velocity = transform.x * speed	



func addFragment():
	
	for i in range(delay):
		var from = history - delay + i
		past_locations.push_back(past_locations[from])
		past_rotations.push_back(past_rotations[from])
		
	for i in range(history - 1, counter, -1):
		past_locations[i] = past_locations[i - delay]
		past_rotations[i] = past_rotations[i - delay]
	
	history += delay
	var f = fragment.instantiate()
	f.lab = str($Fragments.get_child_count())
	$Fragments.call_deferred("add_child",f)
	
func move_fragments():
	
	var wind = get_viewport().get_visible_rect().size
	var p = global_position
	global_position.x = int(wind.x + p.x) % int(wind.x) 
	global_position.y = int(wind.y + p.y) % int(wind.y)
	past_locations[counter] = global_position
	past_rotations[counter] = rotation
	var frag_num = 0
	var d:int = int(2500.0 / speed)
	if d > delay:
		d = delay
	if d < 1:
		d = -d
		
	for i in $Fragments.get_children():
		var old = (history + counter - frag_num * d) % history
		i.global_position = past_locations[old]
		i.rotation = past_rotations[old]
		frag_num += 1
	counter = (counter + 1) % history


	
func _physics_process(delta):
	checkInput(delta)
	move_and_slide()
	move_fragments()
	
