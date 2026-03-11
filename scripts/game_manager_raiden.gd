extends Node

## 雷電風格遊戲管理器
## Raiden-style Game Manager

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal level_changed(new_level: int)
signal game_over
signal game_won

var score: int = 0
var lives: int = 3
var current_level: int = 1
var is_paused: bool = false
var is_game_over: bool = false

# 遊戲統計
var total_enemies_defeated: int = 0
var total_powerups_collected: int = 0
var max_combo: int = 0
var play_time: float = 0.0

func _ready() -> void:
    add_to_group("game_manager")
    print("[Game Manager] 雷電版本初始化 | Raiden Version Initialized")

func _process(delta: float) -> void:
    if not is_paused and not is_game_over:
        play_time += delta
    
    # 檢測暫停
    if Input.is_action_just_pressed("ui_cancel"):
        toggle_pause()

## 開始新遊戲
func start_new_game() -> void:
    score = 0
    lives = 3
    current_level = 1
    is_paused = false
    is_game_over = false
    total_enemies_defeated = 0
    total_powerups_collected = 0
    max_combo = 0
    play_time = 0.0
    
    score_changed.emit(score)
    lives_changed.emit(lives)
    level_changed.emit(current_level)
    
    print("[Game Manager] 新遊戲開始 | New Game Started")

## 增加分數
func add_score(points: int) -> void:
    score += points
    score_changed.emit(score)

## 失去生命
func lose_life() -> void:
    lives -= 1
    lives_changed.emit(lives)
    
    if lives <= 0:
        trigger_game_over()

## 觸發遊戲結束
func trigger_game_over() -> void:
    is_game_over = true
    game_over.emit()
    print("[Game Manager] 遊戲結束 | Game Over")
    print("[Game Manager] 最終分數：%d | Final Score: %d" % score)
    print("[Game Manager] 遊戲時間：%.1f 秒 | Play Time: %.1f s" % play_time)

## 完成關卡
func complete_level() -> void:
    current_level += 1
    level_changed.emit(current_level)
    
    if current_level > 5:
        game_won.emit()
        print("[Game Manager] 遊戲通關！| Game Won!")
    else:
        print("[Game Manager] 關卡 %d 完成 | Level %d Complete" % [current_level - 1, current_level - 1])

## 切換暫停狀態
func toggle_pause() -> void:
    if is_game_over:
        return
    
    is_paused = !is_paused
    get_tree().paused = is_paused
    print("[Game Manager] 暫停狀態：%s" % ("暫停" if is_paused else "繼續"))

## 記錄敵人擊落
func record_enemy_defeated() -> void:
    total_enemies_defeated += 1

## 記錄道具收集
func record_powerup_collected() -> void:
    total_powerups_collected += 1

## 記錄連擊
func record_combo(combo: int) -> void:
    if combo > max_combo:
        max_combo = combo

## 獲取遊戲統計
func get_stats() -> Dictionary:
    return {
        "score": score,
        "lives": lives,
        "level": current_level,
        "enemies_defeated": total_enemies_defeated,
        "powerups_collected": total_powerups_collected,
        "max_combo": max_combo,
        "play_time": play_time
    }
