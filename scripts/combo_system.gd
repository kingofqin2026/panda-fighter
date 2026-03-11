extends Node

## 連擊系統
## Combo System

signal combo_changed(combo: int, multiplier: float)
signal combo_broken

var combo: int = 0
var multiplier: float = 1.0
var combo_timer: float = 0.0
var combo_timeout: float = 3.0  # 3 秒內連續擊落

# 連擊等級
var combo_ranks = ["", "C", "B", "A", "S", "SS", "SSS"]

func _ready() -> void:
    add_to_group("combo_system")

func _process(delta: float) -> void:
    if combo > 0:
        combo_timer -= delta
        if combo_timer <= 0:
            break_combo()

## 增加連擊
func add_combo(points: int = 1) -> int:
    combo += points
    combo_timer = combo_timeout
    
    # 計算倍率
    multiplier = 1.0 + (combo / 10.0)
    multiplier = min(multiplier, 5.0)  # 最大 5 倍
    
    combo_changed.emit(combo, multiplier)
    
    return combo

## 獲取連擊等級
func get_combo_rank() -> String:
    if combo < 10:
        return combo_ranks[0]
    elif combo < 20:
        return combo_ranks[1]
    elif combo < 30:
        return combo_ranks[2]
    elif combo < 50:
        return combo_ranks[3]
    elif combo < 80:
        return combo_ranks[4]
    elif combo < 100:
        return combo_ranks[5]
    else:
        return combo_ranks[6]

## 計算得分
func calculate_score(base_score: int) -> int:
    return int(base_score * multiplier)

## 打破連擊
func break_combo() -> void:
    if combo > 0:
        combo_broken.emit()
        print("[Combo] 連擊中斷！最終：%d x %.1f = %d 分 | Combo broken! Final: %d x %.1f" % [
            combo, multiplier, calculate_score(100), combo, multiplier])
    combo = 0
    multiplier = 1.0

## 重置連擊
func reset_combo() -> void:
    combo = 0
    multiplier = 1.0
    combo_timer = 0.0
