extends Area2D

## 道具腳本
## Power-up Script

enum PowerType {
    WEAPON_UP,      # 武器升級
    HEALTH_UP,      # 生命 +1
    SHIELD,         # 護盾
    SPEED_UP        # 速度提升
}

@export var power_type: PowerType = PowerType.WEAPON_UP
@export var duration: float = 5.0  # 持續時間 (秒)

var speed: float = 100.0

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    
    # 10 秒後自動移除
    var timer = get_tree().create_timer(10.0)
    if timer:
        timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
    position.y += speed * delta
    
    # 左右擺動
    position.x += sin(position.y * 0.05) * 30.0 * delta
    
    # 超出螢幕移除
    if position.y > get_viewport_rect().size.y + 50:
        queue_free()

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        apply_powerup(area)
        queue_free()

func apply_powerup(player: Node) -> void:
    match power_type:
        PowerType.WEAPON_UP:
            if player.has_method("upgrade_weapon"):
                player.upgrade_weapon()
            print("[PowerUp] 武器升級 | Weapon Upgraded")
        
        PowerType.HEALTH_UP:
            var game_manager = get_node_or_null("/root/Main")
            if game_manager:
                # 增加生命 (需要 game_manager 支持)
                game_manager.lives += 1
                game_manager.lives_changed.emit(game_manager.lives)
            print("[PowerUp] 生命 +1 | Life +1")
        
        PowerType.SHIELD:
            if player.has_method("start_invincibility"):
                player.start_invincibility(duration)
            print("[PowerUp] 護盾激活 | Shield Activated")
        
        PowerType.SPEED_UP:
            if player.has_method("set_speed"):
                player.set_speed(player.speed * 1.5)
            print("[PowerUp] 速度提升 | Speed Boost")
