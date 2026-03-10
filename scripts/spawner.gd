extends Node2D

## 敵人生成器
## Enemy Spawner

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 20

var current_enemies: int = 0

func _ready() -> void:
	var spawn_timer = $SpawnTimer
	if spawn_timer:
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		spawn_timer.start(spawn_interval)
	
	print("[Spawner] 敵人生成器已就緒 | Enemy Spawner Ready")

func _on_spawn_timer_timeout() -> void:
	if current_enemies >= max_enemies:
		return
	
	spawn_enemy()

## 生成敵人
func spawn_enemy() -> void:
	if not enemy_scene:
		# 使用默認敵人
		enemy_scene = load("res://scenes/Enemy.tscn")
	
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	if enemy:
		# 隨機 X 位置
		var viewport_width = get_viewport_rect().size.x
		enemy.position.x = randf_range(32, viewport_width - 32)
		enemy.position.y = -32
		
		add_child(enemy)
		current_enemies += 1
		
		# 監聽敵人死亡
		if enemy.has_signal("tree_exited"):
			enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	current_enemies = max(0, current_enemies - 1)

## 設置生成間隔
func set_spawn_interval(interval: float) -> void:
	spawn_interval = interval
	var spawn_timer = $SpawnTimer
	if spawn_timer:
		spawn_timer.wait_time = interval

## 清除所有敵人
func clear_all_enemies() -> void:
	for enemy in get_children():
		if enemy.is_in_group("enemies"):
			enemy.queue_free()
	current_enemies = 0
