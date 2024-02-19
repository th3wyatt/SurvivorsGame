extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var anim_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var land_particles = $Visuals/CPUParticles2D

var jump_timer
@export var has_jumped: bool = false
var finished_entrance

var player
var player_pos
var is_moving
var finished_jumping

func _ready():
	add_to_group("enemy")
	anim_player.connect("animation_finished", _finished_entrance)
	$HurtBoxComponent.hit.connect(on_hit)
	jump_timer = 10.0
	has_jumped = false
	finished_entrance = false
	is_moving = false
	player = get_tree().get_first_node_in_group("player")
	anim_player.play("Entrance")

func _finished_entrance(w):
	finished_entrance = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!finished_entrance): return
	
	if (!has_jumped):
		var temp_timer = jump_timer
		while (temp_timer > 0):
			temp_timer -= 0.05
		is_moving = true
		on_jump()
	
	if (has_jumped):
		player_pos = player.global_position
		var owner_pos = velocity_component.get_owner_pos()
		if (owner_pos == null):
			return
			
		var direction = (player_pos - owner_pos).normalized()
		velocity_component.accelerate_to_player()
		
		if (is_moving):
			velocity_component.move(self)
		
		var move_sign = sign(velocity.x)
		if move_sign != 0:
			visuals.scale = Vector2(-move_sign, 1)
		
		if (owner_pos.distance_to(player_pos) < 1.0):
			is_moving = false
			on_land()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func on_jump():
	if (!anim_player.is_playing()):
		anim_player.play("Jump")
	
func on_land():
	if (!anim_player.is_playing()):
		anim_player.play("Landing")

func on_hit():
	$HitAudioPlayerComponent.play_random()
