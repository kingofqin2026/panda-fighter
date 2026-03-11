extends CanvasLayer

## 雷電風格 HUD
## Raiden-style HUD

@onready var score_value = $MarginContainer/VBoxContainer/ScoreContainer/ScoreValue
@onready var high_score_label = $MarginContainer/VBoxContainer/HighScoreLabel
@onready var combo_value = $MarginContainer/VBoxContainer/ComboContainer/ComboValue
@onready var combo_rank = $MarginContainer/VBoxContainer/ComboContainer/ComboRank
@onready var weapon_value = $MarginContainer/VBoxContainer/WeaponContainer/WeaponValue
@onready var bomb_value = $MarginContainer/VBoxContainer/BombContainer/BombValue
@onready var wingman_value = $MarginContainer/VBoxContainer/WingmanContainer/WingmanValue
@onready var lives_value = $MarginContainer/VBoxContainer/LivesContainer/LivesValue

var high_score: int = 0
var current_score: int = 0

# 武器名稱
var weapon_names = {
    0: "NORMAL",
    1: "LASER",
    2: "MISSILE",
    3: "SPREAD",
    4: "PLASMA"
}

func _ready() -> void:
    # 連接信號
    var game_manager = get_node_or_null("/root/Main")
    if game_manager:
        game_manager.score_changed.connect(_on_score_changed)
        game_manager.lives_changed.connect(_on_lives_changed)
    
    var combo_system = get_node_or_null("/root/Game/ComboSystem")
    if combo_system:
        combo_system.combo_changed.connect(_on_combo_changed)
        combo_system.combo_broken.connect(_on_combo_broken)
    
    var weapon_system = get_node_or_null("/root/Game/WeaponSystem")
    if weapon_system:
        weapon_system.weapon_changed.connect(_on_weapon_changed)
        weapon_system.bomb_used.connect(_on_bomb_used)
    
    var player = get_node_or_null("/root/Game/Player")
    if player:
        player.bomb_count_changed.connect(_on_bomb_count_changed)
        player.weapon_level_changed.connect(_on_player_weapon_changed)
    
    # 加載最高分
    high_score = get_high_score()
    update_high_score_display()
    
    print("[HUD] 初始化完成 | HUD Initialized")

## 分數更新
func _on_score_changed(new_score: int) -> void:
    current_score = new_score
    score_value.text = "%06d" % new_score
    
    # 更新最高分
    if new_score > high_score:
        high_score = new_score
        update_high_score_display()

## 生命更新
func _on_lives_changed(new_lives: int) -> void:
    lives_value.text = "❤️".repeat(new_lives)

## 連擊更新
func _on_combo_changed(combo: int, multiplier: float) -> void:
    combo_value.text = "x%.1f" % multiplier
    
    # 獲取連擊等級
    var combo_system = get_node_or_null("/root/Game/ComboSystem")
    if combo_system and combo_system.has_method("get_combo_rank"):
        var rank = combo_system.get_combo_rank()
        combo_rank.text = rank
        
        # 根據等級改變顏色
        match rank:
            "C":
                combo_rank.modulate = Color(0.5, 0.5, 1)
            "B":
                combo_rank.modulate = Color(0.5, 1, 0.5)
            "A":
                combo_rank.modulate = Color(1, 1, 0.5)
            "S":
                combo_rank.modulate = Color(1, 0.8, 0.2)
            "SS":
                combo_rank.modulate = Color(1, 0.5, 0.2)
            "SSS":
                combo_rank.modulate = Color(1, 0.2, 0.5)

## 連擊中斷
func _on_combo_broken() -> void:
    combo_value.text = "x1.0"
    combo_rank.text = ""

## 武器更新
func _on_weapon_changed(weapon_type: int, level: int) -> void:
    var weapon_name = weapon_names.get(weapon_type, "NORMAL")
    weapon_value.text = "%s Lv.%d" % [weapon_name, level]

## 炸彈使用
func _on_bomb_used() -> void:
    # 炸彈計數由 player 更新
    pass

## 炸彈數量更新
func _on_bomb_count_changed(count: int) -> void:
    bomb_value.text = "💣".repeat(count)

## 玩家武器升級
func _on_player_weapon_changed(level: int) -> void:
    weapon_value.text = "NORMAL Lv.%d" % level

## 更新最高分顯示
func update_high_score_display() -> void:
    high_score_label.text = "HI-%06d" % high_score
    # 保存最高分
    save_high_score(high_score)

## 保存最高分
func save_high_score(score: int) -> void:
    var config = ConfigFile.new()
    config.set_value("game", "high_score", score)
    config.save("user://high_score.cfg")

## 加載最高分
func get_high_score() -> int:
    var config = ConfigFile.new()
    var err = config.load("user://high_score.cfg")
    if err == OK:
        return config.get_value("game", "high_score", 0)
    return 0

## 顯示道具收集提示
func show_powerup_message(powerup_type: String) -> void:
    # 可以在這裡添加道具收集的視覺反饋
    print("[HUD] 收集 %s | Collected %s" % [powerup_type, powerup_type])
