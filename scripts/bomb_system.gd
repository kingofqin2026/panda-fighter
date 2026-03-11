extends Node

## 炸彈系統
## Bomb System

signal bomb_activated
signal bomb_finished

var is_active: bool = false
var duration: float = 2.0
var damage: int = 100

func _ready() -> void:
    add_to_group("bomb_system")

## 使用炸彈
func activate_bomb() -> void:
    if is_active:
        return
    
    is_active = true
    bomb_activated.emit()
    
    # 對所有敵人造成傷害
    var enemies = get_tree().get_nodes_in_group("enemies")
    for enemy in enemies:
        if enemy.has_method("take_damage"):
            enemy.take_damage(damage)
    
    # 播放特效（待實現）
    print("[Bomb] 炸彈爆發！擊中 %d 個敵人 | Bomb activated! Hit %d enemies" % [enemies.size(), enemies.size()])
    
    # 炸彈結束後
    await get_tree().create_timer(duration).timeout
    is_active = false
    bomb_finished.emit()

## 獲取炸彈範圍內敵人
func get_enemies_in_bomb_radius() -> Array:
    var enemies = get_tree().get_nodes_in_group("enemies")
    var in_radius = []
    
    for enemy in enemies:
        if enemy.position.y < get_viewport_rect().size.y:
            in_radius.append(enemy)
    
    return in_radius
