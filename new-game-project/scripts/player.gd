extends CharacterBody2D

# game stat variables
@export var speed: int = 300
# defence/armour stats
@export var max_defence = 500:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		max_defence = value
		DefenceBar.max_value = max_defence
var defence: int = 0:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		if value > max_defence:
			value = max_defence
		defence = value
		if defence <= 0:
			armour_break()
		print("defence updated")
		DefenceBar.value = defence
# health stats
@export var max_health = 500:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		max_health = value
		HealthBar.max_value = max_health
var health: int = 0:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		print(health)
		print(value)
		if value > max_health:
			value = max_health
		health = value
		if health <= 0:
			die()
		print("health updated: " + str(health))
		HealthBar.value = health
# stamina stats
@export var max_stamina = 500:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		max_stamina = value
		StaminaBar.max_value = max_stamina
var stamina: int = 0:
	set(value):
		# kick out anyone who isn't the player in control
		if !is_multiplayer_authority(): return
		if value > max_stamina:
			value = max_stamina
		stamina = value
		print("stamina updated")
		StaminaBar.value = stamina

# Logic variables
@export var CustomMultiplayerSpawner: PackedScene
@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var PlayerSprite: Sprite2D = $PlayerSprite
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var DefenceBar: ProgressBar = $StatBars/DefenceBar
@onready var HealthBar: ProgressBar = $StatBars/HealthBar
@onready var StaminaBar: ProgressBar = $StatBars/StaminaBar

func _ready() -> void:
	# connect the signals and functions
	multiplayer.peer_disconnected.connect(despawn_player)
	PvpManager.output_damage_signal.connect(take_damage)
	# make the player camera the current camera for the client controlling them
	if is_multiplayer_authority():
		PlayerCamera.make_current()
	# move the player to the middle (will be changed to spawn points when menus are added)
	position = Vector2(1000,200)
	# update all health bars to the starting max health
	DefenceBar.max_value = max_defence
	HealthBar.max_value = max_health
	StaminaBar.max_value = max_stamina
	# set all the stats to the starting numbers, using self. to force the setter code to run
	defence = max_defence
	health = max_health
	stamina = max_stamina

func _enter_tree() -> void:
	# give the client authority over their player
	set_multiplayer_authority(name.to_int())

func _process(_delta: float) -> void:
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
	move_and_slide()
	
	# make the player sprite point towards their cusor (doesn't affect hitbox)
	PlayerSprite.rotation = get_angle_to(get_global_mouse_position())

# despawns the player when the disconnect
func despawn_player(id) -> void:
	if id == int(name):
		queue_free()

# manages what happens when the player's armour breaks
func armour_break() -> void:
	pass

# manages what happens when the player dies
func die() -> void:
	pass

func heal(healing) -> void:
	health += healing

func take_damage(user_id: String,damage: int):
	# cancel if the signal is coming from self
	if name == user_id: return
	health -= damage
	print("damage dealt")

func _on_damage_button_pressed() -> void:
	PvpManager.output_damage(name,50)

func _on_heal_button_pressed() -> void:
	heal(50)
