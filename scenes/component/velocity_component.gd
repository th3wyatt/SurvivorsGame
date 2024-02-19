extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO
var position = Vector2.ZERO

func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
		
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)
#
#func reset():
	#velocity = Vector2.ZERO

func easeInOutQuint(x):
	if (x < 0.5):
		return 16 * x * x * x * x * x
	return 1 - pow(-2 * x + 2, 5) / 2

func jump_to_player(player_pos, t):
	var owner_node2d = owner as Node2D
	position = owner_node2d.global_position
	#var direction = (player_pos - owner_node2d.global_position).normalized()
	position = position.lerp(player_pos, 1 - pow(1 - t, 5))
	#velocity = velocity.lerp(direction * max_speed, 1 - pow(1 - t, 5))
	

func get_owner_pos():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return null
	
	return owner_node2d.global_position

func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(
		desired_velocity, 
		1 - exp(-acceleration * get_process_delta_time())
	)

func decelerate():
	accelerate_in_direction(Vector2.ZERO)

func transform_move(character: Node2D):
	character.global_position = position
	character.move_and_slide()
	position = character.global_position

func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
