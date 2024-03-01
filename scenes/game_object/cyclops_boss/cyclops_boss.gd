extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var anim_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var land_particles = $Visuals/CPUParticles2D
@onready var timer = $Timer

@export var has_jumped: bool = false
@export var finished_entrance: bool = false
@export var once_check: bool = false

var player
var player_pos
var finished_jumping
var duration = 1.0
var elapsed_time = 0.0

func _ready():
	add_to_group("enemy")
	$HurtBoxComponent.hit.connect(on_hit)
	timer.timeout.connect(_jump_ready)
	player = get_tree().get_first_node_in_group("player")
	anim_player.play("Entrance")
	timer.start()
	duration = 1.0
	elapsed_time = 0.0
	once_check = false

func _jump_ready():
	player_pos = player.global_position
	print("GOT POSITION:")
	print(player_pos)
	elapsed_time = 0.0
	on_jump()

func go_towards_player(elapsed_time, duration):
	velocity_component.jump_to_player(player_pos, elapsed_time / duration)
	velocity_component.transform_move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!finished_entrance): return 
	if (has_jumped):
		if (elapsed_time < duration):
			go_towards_player(elapsed_time, duration)
			elapsed_time += get_process_delta_time()
		else:
			if (once_check): return
			print("ITS OVER")
			has_jumped = false
			#velocity_component.reset()
			on_land()

func on_jump():
	if (!anim_player.is_playing()):
		anim_player.play("Jump")
	
func on_land():
	if (!anim_player.is_playing()):
		anim_player.play("Landing")

func on_hit():
	$HitAudioPlayerComponent.play_random()
