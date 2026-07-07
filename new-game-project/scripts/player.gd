extends CharacterBody2D
class_name Player
@export var speed: int = 300
@export var CustomMultiplayerSpawner: PackedScene
@onready var screen_size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	# connect the disconnect signal to the despawn func
	multiplayer.peer_disconnected.connect(despawn_player)

func _enter_tree() -> void:
	# give the player authority over themself
	set_multiplayer_authority(name.to_int())

func _process(delta: float) -> void:
	# kick out anyone who isn't the player in control
	if !is_multiplayer_authority(): return
	
	# reset the player's velocity
	velocity = Vector2.ZERO 
	# change the velocity to match the player's inputs
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	# normalise the velocity so diagonals are not faster
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	# move the player
	position += velocity * delta

func despawn_player(id):
	if id == int(name):
		queue_free()
