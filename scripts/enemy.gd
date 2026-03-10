extends Area2D

## 敵人基礎腳本
## Enemy Base Script

@export var health: int = 1
@export var speed: float = 100.0
@export var score_value: int = 100
@export var move_pattern: String = "straight"  # straight, sine, zigzag

var direction: float = 1.0
var start_x: float = 0.0

func _ready() -> void:
	add_to_group("enemies")
	start_x = position.x
	
	# 連接信號
	area_entered.connect(_on_area_entered)
	
	# 射擊計時器
	var shoot_timer = $ShootTimer
	if shoot_timer:
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		shoot_timer.start(randf_range(1.0, 3.0))

func _physics_process(delta: float) -> void:
	# 向下移動
	position.y += speed * delta
	
	# 移動模式
	match move_pattern:
		"sine":
			position.x = start_x + sin(position.y * 0.05) * 50.0
		"zigzag":
			position.x += direction * 50.0 * delta
			if position.x > start_x + 100 or position.x < start_x - 100:
				direction *= -1
	
	# 超出螢幕移除
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	# 撞到玩家
	if area.is_in_group("player"):
		if area.has_method("take_damage"):
			area.take_damage(1)
		queue_free()

func _on_shoot_timer_timeout() -> void:
	# 子類可覆寫此方法實現射擊
	pass

## 受到傷害
func take_damage(amount: int) -> void:
	health -= amount
	
	if health <= 0:
		die()

## 死亡
func die() -> void:
	var game_manager = get_node_or_null("/root/Main")
	if game_manager:
		game_manager.add_score(score_value)
	
	queue_free()
