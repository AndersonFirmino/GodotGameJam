extends "res://scenes/characters/character.gd"

var item_a
var item_b
onready var ray_interact = get_node("ray_interact")

func _init():
	add_to_group("player")
	Globals.set("player", self)

func _ready():
	set_process_input(true)
	ray_interact.add_exception(self)

func _input(event):
	dir = Vector2()
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	
	if anim.get_current_animation() == "attack":
		dir.normalized()
		return
	
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0: set_facing(LEFT)
		else: set_facing(RIGHT)
	elif abs(dir.x) < abs(dir.y):
		if dir.y > 0: set_facing(DOWN)
		else: set_facing(UP)
	dir.normalized()
	
	if event.is_action_pressed("A"):
		if not interact():
			if item_a != null:
				item_a.use()
	if item_a != null && event.is_action_released("A"):
		item_a.release()
	if item_b != null && event.is_action_pressed("B"):
		item_b.use()
	if item_b != null && event.is_action_released("B"):
		item_b.release()

func set_facing(new_dir):
	if new_dir == UP:
		ray_interact.set_cast_to(Vector2(0,-20))
	elif new_dir == DOWN:
		ray_interact.set_cast_to(Vector2(0,20))
	elif new_dir == LEFT:
		ray_interact.set_cast_to(Vector2(20,0))
	elif new_dir == RIGHT:
		ray_interact.set_cast_to(Vector2(-20,0))
	.set_facing(new_dir) # Call character.gd 's set_facing function
	
func interact():
	if not ray_interact.is_colliding():
		return false
	if ray_interact.get_collider().is_in_group("interactable"):
		return ray_interact.get_collider().interact()
	else:
		return false