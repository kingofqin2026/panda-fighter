extends Area2D

## 雷電風格敵機系統
## Raiden-style Enemy System

enum EnemyType {
    FIGHTER,      # 小戰鬥機
    BOMBER,       # 轟炸機
    SCOUT,        # 偵察機
    GUARD,        # 護衛機
    ELITE         # 精英機
}

@export var enemy_type: EnemyType = EnemyType.FIGHTER
@export var health: int = 1
@export var max_health: int = 1
@export var speed: float = 100.0
@export var score_value: int = 100
@export var move_pattern: String = "straight"

# 道具掉落配置
var drop_table = {
    EnemyType.FIGHTER: {
        "red_crystal": 0.3,      # 30% 掉落紅水晶
        "blue_crystal": 0.1,     # 10% 掉落藍水晶
        "none": 0.6
    },
    EnemyType.BOMBER: {
        "blue_crystal": 0.4,
        "yellow_crystal": 0.2,
        "none": 0.4
    },
    EnemyType.SCOUT: {
        "green_crystal": 0.4,
        "lightning": 0.2,
        "none": 0.4
    },
    EnemyType.GUARD: {
        "yellow_crystal": 0.4,
        "heart": 0.2,
        "red_crystal": 0.2,
        "none": 0.2
    },
    EnemyType.ELITE: {
        "red_crystal": 0.3,
        "blue_crystal": 0.2,
        "green_crystal": 0.2,
        "yellow_crystal": 0.2,
        "heart": 0.1,
        "none": 0.0
    }
}

var direction: float = 1.0
var start_x: float = 0.0
var player_target: Node2D = null

# 敵機配置
var enemy_configs = {
    EnemyType.FIGHTER: {
        "health": 1,
        "speed": 120.0,
        "score": 100,
        "pattern": "sine"
    },
    EnemyType.BOMBER: {
        "health": 3,
        "speed": 80.0,
        "score": 300,
        "pattern": "straight"
    },
    EnemyType.SCOUT: {
        "health": 1,
        "speed": 180.0,
        "score": 200,
        "pattern": "chase"
    },
    EnemyType.GUARD: {
        "health": 5,
        "speed": 60.0,
        "score": 500,
        "pattern": "zigzag"
    },
    EnemyType.ELITE: {
        "health": 10,
        "speed": 100.0,
        "score": 1000,
        "pattern": "sine"
    }
}

func _ready() -> void:
    add_to_group("enemies")
    start_x = position.x
    
    # 根據類型配置屬性
    apply_enemy_config()
    
    # 連接信號
    area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
    # 移動模式
    match move_pattern:
        "straight":
            position.y += speed * delta
        "sine":
            position.y += speed * delta
            position.x = start_x + sin(position.y * 0.05) * 50.0
        "zigzag":
            position.y += speed * delta
            position.x += direction * 50.0 * delta
            if position.x > start_x + 100 or position.x < start_x - 100:
                direction *= -1
        "chase":
            position.y += speed * delta
            if player_target:
                if position.x < player_target.position.x:
                    position.x += 30.0 * delta
                else:
                    position.x -= 30.0 * delta
    
    # 超出螢幕移除
    if position.y > get_viewport_rect().size.y + 50:
        queue_free()

func apply_enemy_config() -> void:
    if enemy_configs.has(enemy_type):
        var config = enemy_configs[enemy_type]
        health = config.health
        max_health = config.health
        speed = config.speed
        score_value = config.score
        move_pattern = config.pattern

## 設置玩家目標（用於追蹤）
func set_player_target(target: Node2D) -> void:
    player_target = target

## 受到傷害
func take_damage(amount: int) -> void:
    health -= amount
    
    if health <= 0:
        die()

## 死亡
func die() -> void:
    # 掉落道具
    drop_powerup()
    
    # 加分
    var game_manager = get_node_or_null("/root/Main")
    if game_manager:
        # 如果有連擊系統，使用連擊倍率
        var combo_system = get_node_or_null("/root/Game/ComboSystem")
        if combo_system and combo_system.has_method("calculate_score"):
            var score = combo_system.calculate_score(score_value)
            game_manager.add_score(score)
            combo_system.add_combo(1)
        else:
            game_manager.add_score(score_value)
    
    queue_free()

## 掉落道具
func drop_powerup() -> void:
    var drops = drop_table.get(enemy_type, {"none": 1.0})
    var roll = randf()
    var accumulated = 0.0
    
    for powerup in drops:
        accumulated += drops[powerup]
        if roll <= accumulated and powerup != "none":
            spawn_powerup(powerup)
            break

## 生成道具
func spawn_powerup(powerup_type: String) -> void:
    # 這裡會由 spawner 系統處理
    # 創建一個道具生成請求
    var powerup_scene = load("res://scenes/PowerUp.tscn")
    if powerup_scene:
        var powerup = powerup_scene.instantiate()
        if powerup:
            powerup.position = position
            # 設置道具類型
            match powerup_type:
                "red_crystal":
                    powerup.power_type = 0  # RED_CRYSTAL
                "blue_crystal":
                    powerup.power_type = 1  # BLUE_CRYSTAL
                "green_crystal":
                    powerup.power_type = 2  # GREEN_CRYSTAL
                "yellow_crystal":
                    powerup.power_type = 3  # YELLOW_CRYSTAL
                "heart":
                    powerup.power_type = 4  # HEART
                "lightning":
                    powerup.power_type = 5  # LIGHTNING
                "shield":
                    powerup.power_type = 6  # SHIELD
            get_tree().current_scene.add_child(powerup)
            print("[Enemy] 掉落 %s | Dropped %s" % [powerup_type, powerup_type])

## 獲取敵人類型名稱
func get_type_name() -> String:
    return EnemyType.keys()[enemy_type]
