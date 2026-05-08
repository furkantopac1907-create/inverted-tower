extends CharacterBody2D

# â”€â”€ constants â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const SPEED          := 75.0
const GRAVITY        := 1200.0
const MAX_HP         := 3
const ATTACK_RANGE   := 58.0
const ATTACK_DAMAGE  := 1
const ATTACK_DUR     := 0.55
const ATTACK_COOLDOWN := 1.8
const HURT_DUR       := 0.30

const SPRITE_BASE := "res://assets/sprites/characters/zombie_enemy/animations/"
const ANIM_WALK   := "Walking-f6b45c0f"
const ANIM_ATTACK := "The_character_leans_slightly_into_a_sudden_upward-e3745352"

# â”€â”€ state machine â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
enum State { IDLE, CHASE, ATTACK, HURT, DEAD }
var state : int = State.IDLE

# â”€â”€ runtime vars â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
var hp              : int               = MAX_HP
var _player         : CharacterBody2D   = null
var _facing_right   : bool              = true
var _attack_timer   : float             = 0.0
var _attack_cooldown: float             = 0.0
var _hurt_timer     : float             = 0.0
var _hit_landed     : bool              = false

# â”€â”€ nodes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
@onready var sprite         : AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_zone : Area2D           = $DetectionZone

# â”€â”€ init â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
func _ready() -> void:
	add_to_group("enemy")
	_build_sprite_frames()
	detection_zone.body_entered.connect(_on_body_entered_detection)
	detection_zone.body_exited.connect(_on_body_exited_detection)
	sprite.play("walk")

func _build_sprite_frames() -> void:
	var sf : SpriteFrames = SpriteFrames.new()
	sf.remove_animation("default")
	_add_anim(sf, "walk",   ANIM_WALK,   6,  9.0, true)
	_add_anim(sf, "attack", ANIM_ATTACK, 5, 10.0, false)
	sprite.sprite_frames = sf

func _add_anim(sf: SpriteFrames, anim: String, folder: String, frames: int, fps: float, loop: bool) -> void:
	sf.add_animation(anim)
	sf.set_animation_speed(anim, fps)
	sf.set_animation_loop(anim, loop)
	var path : String = SPRITE_BASE + folder + "/south-east/"
	for i in frames:
		var tex : Texture2D = load(path + "frame_%03d.png" % i)
		if tex:
			sf.add_frame(anim, tex)

# â”€â”€ physics â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if _attack_cooldown > 0.0:
		_attack_cooldown -= delta

	match state:
		State.IDLE:
			velocity.x = move_toward(velocity.x, 0.0, SPEED * 8.0 * delta)
		State.CHASE:
			_tick_chase(delta)
		State.ATTACK:
			_tick_attack(delta)
		State.HURT:
			_tick_hurt(delta)

	move_and_slide()

# â”€â”€ state ticks â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
func _tick_chase(delta: float) -> void:
	if not is_instance_valid(_player):
		state = State.IDLE
		return

	var dist : float = global_position.distance_to(_player.global_position)

	if dist <= ATTACK_RANGE and _attack_cooldown <= 0.0:
		_begin_attack()
		return

	var dir : float = sign(_player.global_position.x - global_position.x)
	velocity.x = move_toward(velocity.x, dir * SPEED, SPEED * 8.0 * delta)
	_set_facing(dir >= 0.0)
	if sprite.animation != "walk":
		sprite.play("walk")

func _begin_attack() -> void:
	state = State.ATTACK
	_attack_timer = ATTACK_DUR
	_hit_landed   = false
	velocity.x    = 0.0
	sprite.play("attack")

func _tick_attack(delta: float) -> void:
	_attack_timer -= delta

	# land the hit at 40% through the swing (just past the windup)
	if not _hit_landed and _attack_timer <= ATTACK_DUR * 0.6:
		_hit_landed      = true
		_attack_cooldown = ATTACK_COOLDOWN
		if is_instance_valid(_player):
			var dist : float = global_position.distance_to(_player.global_position)
			if dist <= ATTACK_RANGE + 12.0:
				_player.take_damage(ATTACK_DAMAGE)

	if _attack_timer <= 0.0:
		state = State.CHASE if is_instance_valid(_player) else State.IDLE

func _tick_hurt(delta: float) -> void:
	_hurt_timer -= delta
	velocity.x   = move_toward(velocity.x, 0.0, SPEED * 8.0 * delta)
	if _hurt_timer <= 0.0:
		state = State.CHASE if is_instance_valid(_player) else State.IDLE

# â”€â”€ damage / death â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
func take_damage(amount: int) -> void:
	if state == State.DEAD:
		return
	hp -= amount
	if hp <= 0:
		_die()
		return
	state       = State.HURT
	_hurt_timer = HURT_DUR
	sprite.modulate = Color(1.0, 0.25, 0.25)
	get_tree().create_timer(HURT_DUR).timeout.connect(
		func(): if is_instance_valid(self): sprite.modulate = Color.WHITE
	)

func _die() -> void:
	state = State.DEAD
	set_physics_process(false)
	EventBus.enemy_died.emit(self)
	sprite.modulate = Color(0.45, 0.45, 0.45)
	await get_tree().create_timer(0.9).timeout
	queue_free()

# â”€â”€ helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
func _set_facing(right: bool) -> void:
	if _facing_right == right:
		return
	_facing_right  = right
	sprite.flip_h  = not right

func _on_body_entered_detection(body: Node2D) -> void:
	if body.is_in_group("player") and state != State.DEAD:
		_player = body as CharacterBody2D
		state   = State.CHASE

func _on_body_exited_detection(body: Node2D) -> void:
	if body == _player:
		_player = null
		if state == State.CHASE:
			state = State.IDLE
