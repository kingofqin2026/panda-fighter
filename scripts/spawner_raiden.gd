extends Node2D

## 雷電風格敵人生成器
## Raiden-style Enemy Spawner

@export var enemy_scene: PackedScene
@export var powerup_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 20

var current_enemies: int = 0
var level: int = 1
var spawn_timer_value: float = 0.0

# 關卡敵機配置
var level_configs = {
    1: {
        "enemies": ["FIGHTER", "FIGHTER", "BOMBER"],
        "interval": 2.0,
        "max": 15
    },
    2: {
        "enemies": ["FIGHTER", "BOMBER", "SCOUT"],
        "interval": 1.8,
        "max": 18
    },
    3: {
        "enemies": ["BOMBER", "SCOUT", "GUARD"],
        "interval": 1.5,
        "max": 20
    },
    4: {
        "enemies": ["SCOUT", "GUARD", "ELITE"],
        "interval": 1.3,
        "max": 22
    },
    5: {
        "enemies": ["GUARD", "ELITE", "BOSS"],
        "interval": 1.0,
        "max": 25
    }
}

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
        enemy_scene = load("res://scenes/Enemy.tscn")
    
    if not enemy_scene:
        return
    
    # 根據關卡選擇敵人類型
    var enemy_type = get_enemy_for_level()
    
    var enemy = enemy_scene.instantiate()
    if enemy:
        # 隨機 X 位置
        var viewport_width = get_viewport_rect().size.x
        enemy.position.x = randf_range(32, viewport_width - 32)
        enemy.position.y = -32
        
        # 設置敵人類型
        if enemy.has_method("set_enemy_type"):
            enemy.set_enemy_type(enemy_type)
        
        # 設置玩家目標（用於追蹤型敵人）
        var player = get_node_or_null("/root/Game/Player")
        if player and enemy.has_method("set_player_target"):
            enemy.set_player_target(player)
        
        add_child(enemy)
        current_enemies += 1
        
        # 監聽敵人死亡
        if enemy.has_signal("tree_exited"):
            enemy.tree_exited.connect(_on_enemy_died)

## 根據關卡獲取敵人類型
func get_enemy_for_level() -> int:
    if level_configs.has(level):
        var config = level_configs[level]
        var enemies = config.enemies
        var random_idx = randi() % enemies.size()
        return EnemyType.keys().find(enemies[random_idx])
    else:
        return 0  # FIGHTER

## 設置關卡
func set_level(new_level: int) -> void:
    level = new_level
    if level_configs.has(level):
        var config = level_configs[level]
        spawn_interval = config.interval
        max_enemies = config.max
        print("[Spawner] 關卡 %d | Level %d - Interval: %.1f, Max: %d" % [
            level, level, spawn_interval, max_enemies])

## 敵人死亡回調
func _on_enemy_died() -> void:
    current_enemies = max(0, current_enemies - 1)

## 清除所有敵人
func clear_all_enemies() -> void:
    for enemy in get_children():
        if enemy.is_in_group("enemies"):
            enemy.queue_free()
    current_enemies = 0

## 生成 Boss
func spawn_boss() -> void:
    var boss_scene = load("res://scenes/Boss.tscn")
    if boss_scene:
        var boss = boss_scene.instantiate()
        if boss:
            boss.position = Vector2(get_viewport_rect().size.x / 2, -100)
            add_child(boss)
            print("[Spawner] Boss 生成！| Boss Spawned!")
