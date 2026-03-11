extends Node

## 雷電風格武器系統
## Raiden-style Weapon System

signal weapon_changed(weapon_type: String, level: int)
signal bomb_used
signal power_changed(power: int)

# 武器類型
enum WeaponType {
    NORMAL,     # 普通子彈
    LASER,      # 激光
    MISSILE,    # 導彈
    SPREAD,     # 散射
    PLASMA      # 等離子
}

# 武器配置
var current_weapon: WeaponType = WeaponType.NORMAL
var weapon_level: int = 1
var max_level: int = 5
var bomb_count: int = 3
var wingmen: int = 0

# 武器傷害配置
var weapon_damage = {
    WeaponType.NORMAL: [1, 2, 3, 4, 5],
    WeaponType.LASER: [2, 3, 4, 5, 6],
    WeaponType.MISSILE: [3, 4, 5, 6, 7],
    WeaponType.SPREAD: [1, 2, 3, 4, 5],
    WeaponType.PLASMA: [2, 3, 4, 5, 8]
}

# 武器射速
var weapon_fire_rate = {
    WeaponType.NORMAL: [0.15, 0.13, 0.11, 0.09, 0.07],
    WeaponType.LASER: [0.2, 0.18, 0.16, 0.14, 0.12],
    WeaponType.MISSILE: [0.5, 0.45, 0.4, 0.35, 0.3],
    WeaponType.SPREAD: [0.2, 0.18, 0.16, 0.14, 0.12],
    WeaponType.PLASMA: [0.3, 0.27, 0.24, 0.21, 0.18]
}

func _ready() -> void:
    add_to_group("weapon_system")

## 升級武器
func upgrade_weapon(points: int = 1) -> void:
    weapon_level = min(weapon_level + points, max_level)
    weapon_changed.emit(current_weapon, weapon_level)
    print("[Weapon] 升級到等級 %d | Upgraded to level %d" % [weapon_level, weapon_level])

## 切換武器
func switch_weapon(new_weapon: WeaponType) -> void:
    current_weapon = new_weapon
    weapon_changed.emit(current_weapon, weapon_level)
    print("[Weapon] 切換到 %s | Switched to %s" % [WeaponType.keys()[new_weapon], WeaponType.keys()[new_weapon]])

## 使用炸彈
func use_bomb() -> bool:
    if bomb_count > 0:
        bomb_count -= 1
        bomb_used.emit()
        print("[Weapon] 使用炸彈！剩餘 %d | Bomb used! Remaining: %d" % [bomb_count, bomb_count])
        return true
    return false

## 添加炸彈
func add_bomb(count: int = 1) -> void:
    bomb_count += count
    print("[Weapon] 炸彈 + %d | Bomb + %d" % [count, count])

## 添加僚機
func add_wingman() -> void:
    wingmen = min(wingmen + 1, 4)
    print("[Weapon] 僚機 +1 | Wingman +1, Total: %d" % wingmen)

## 獲取當前武器傷害
func get_current_damage() -> int:
    return weapon_damage[current_weapon][weapon_level - 1]

## 獲取當前射速
func get_current_fire_rate() -> float:
    return weapon_fire_rate[current_weapon][weapon_level - 1]

## 重置武器
func reset_weapon() -> void:
    weapon_level = 1
    current_weapon = WeaponType.NORMAL
    weapon_changed.emit(current_weapon, weapon_level)
