extends Area2D

## 玩家控制器 - 熊貓戰機
## Player Controller - Panda Fighter

@export var speed: float = 300.0
@export var health: int = 3
@export var bullet_scene: PackedScene

var can_shoot: bool = true
var shoot_delay: float = 0.15
var power_level: int = 1
var is_invincible: bool = false

# 信號
signal player_hit
signal player_died

func _ready() -> void:
	# 連接到遊戲管理器
	var game_manager = get_node_or_null("/root/Main")
	if game_manager:
		game_manager.set_player(self)
	
	# 設置射擊計時器
	var shoot_timer = $ShootTimer
	if shoot_timer:
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		shoot_timer.start(shoot_delay)
	
	print("[Player] 熊貓戰機已就緒 | Panda Fighter Ready")

func _physics_process(delta: float) -> void:
	if is_invincible:
		return
	
	# 獲取輸入
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
	if Input.is_action_pressed("move_up"):
		input_direction.y -= 1
	
	# 移動
	if input_direction != Vector2.ZERO:
		position += input_direction.normalized() * speed * delta
	
	# 邊界限制
	var viewport_size = get_viewport_rect().size
	position.x = clamp(position.x, 16, viewport_size.x - 16)
	position.y = clamp(position.y, 16, viewport_size.y - 16)
	
	# 射擊（自動）
	if can_shoot and not is_invincible:
		shoot()

func shoot() -> void:
	if not bullet_scene:
		return
	
	var bullet = bullet_scene.instantiate()
	if bullet:
		bullet.position = position
		bullet.power = power_level
		get_tree().current_scene.add_child(bullet)
		can_shoot = false

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

## 受到傷害
func take_damage(amount: int) -> void:
	if is_invincible:
		return
	
	health -= amount
	player_hit.emit()
	
	# 短暫無敵
	start_invincibility(1.0)
	
	if health <= 0:
		player_died.emit()
		die()

## 開始無敵狀態
func start_invincibility(duration: float) -> void:
	is_invincible = true
	visible = false
	
	await get_tree().create_timer(duration).timeout
	
	is_invincible = false
	visible = true

## 死亡
func die() -> void:
	var game_manager = get_node_or_null("/root/Main")
	if game_manager:
		game_manager.lose_life()
	
	queue_free()

## 升級武器
func upgrade_weapon() -> void:
	power_level = min(power_level + 1, 3)
	print("[Player] 武器升級到等級 %d | Weapon upgraded to level %d" % [power_level, power_level])
