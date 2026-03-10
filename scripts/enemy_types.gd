extends Node

## 敵人類型管理器
## Enemy Type Manager - 5 種敵人類型配置

# 敵人配置數據結構
class EnemyConfig:
    var name: String
    var health: int
    var speed: float
    var score_value: int
    var move_pattern: String
    var shoot_pattern: String
    var color: Color
    var size: float
    
    func _init(n: String, h: int, s: float, sc: int, mp: String, sp: String, c: Color, sz: float):
        name = n
        health = h
        speed = s
        score_value = sc
        move_pattern = mp
        shoot_pattern = sp
        color = c
        size = sz

# 5 種敵人類型配置
static func get_enemy_configs() -> Dictionary:
    return {
        "bird": EnemyConfig.new(
            "小鳥戰機",      # name
            1,               # health
            120.0,           # speed
            100,             # score
            "sine",          # move_pattern (正弦移動)
            "none",          # shoot_pattern
            Color(1.0, 0.4, 0.4),  # 紅色
            1.0              # size multiplier
        ),
        "bee": EnemyConfig.new(
            "蜜蜂轟炸機",
            2,
            80.0,
            200,
            "straight",
            "bomb",          # 投擲炸彈
            Color(1.0, 0.85, 0.2),  # 黃色
            1.2
        ),
        "crow": EnemyConfig.new(
            "烏鴉偵察機",
            1,
            180.0,
            150,
            "chase",         # 追蹤玩家
            "none",
            Color(0.4, 0.4, 0.4),  # 灰色
            0.8
        ),
        "owl": EnemyConfig.new(
            "貓頭鷹護衛",
            5,
            60.0,
            500,
            "zigzag",
            "straight",      # 直線射擊
            Color(0.6, 0.4, 0.8),  # 紫色
            1.5
        ),
        "eagle": EnemyConfig.new(
            "老鷹精英",
            3,
            100.0,
            300,
            "sine",
            "spread",        # 多方向子彈
            Color(0.2, 0.8, 0.4),  # 綠色
            1.3
        )
    }

# 根據關卡返回敵人生成配置
static func get_level_enemies(level: int) -> Array:
    match level:
        1:
            return ["bird", "bird", "bird", "bee"]
        2:
            return ["bird", "bee", "crow", "crow"]
        3:
            return ["bee", "crow", "owl", "owl"]
        4:
            return ["crow", "owl", "eagle", "eagle"]
        5:
            return ["owl", "eagle", "eagle", "boss"]
        _:
            return ["bird"]

# 創建敵人實例
static func create_enemy(enemy_type: String, enemy_scene: PackedScene) -> Node:
    var configs = get_enemy_configs()
    if not configs.has(enemy_type):
        return null
    
    var config = configs[enemy_type]
    var enemy = enemy_scene.instantiate()
    
    if enemy:
        # 設置屬性
        if enemy.has_method("set_config"):
            enemy.set_config(config)
    
    return enemy
