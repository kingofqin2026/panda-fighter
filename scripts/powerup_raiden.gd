extends Area2D

## 雷電風格道具系統
## Raiden-style Power-up System

enum PowerType {
    RED_CRYSTAL,      # 紅水晶 - 主武器升級
    BLUE_CRYSTAL,     # 藍水晶 - 副武器升級
    GREEN_CRYSTAL,    # 綠水晶 - 僚機 +1
    YELLOW_CRYSTAL,   # 黃水晶 - 炸彈 +1
    HEART,            # 紅心 - 生命 +1
    LIGHTNING,        # 閃電 - 速度提升
    SHIELD            # 護盾 - 短暂无敵
}

@export var power_type: PowerType = PowerType.RED_CRYSTAL
var speed: float = 80.0
var rotation_speed: float = 2.0

# 道具顏色
var power_colors = {
    PowerType.RED_CRYSTAL: Color(1, 0.2, 0.2),
    PowerType.BLUE_CRYSTAL: Color(0.2, 0.4, 1),
    PowerType.GREEN_CRYSTAL: Color(0.2, 1, 0.4),
    PowerType.YELLOW_CRYSTAL: Color(1, 1, 0.2),
    PowerType.HEART: Color(1, 0.3, 0.5),
    PowerType.LIGHTNING: Color(1, 0.8, 0.2),
    PowerType.SHIELD: Color(0.5, 0.8, 1)
}

# 道具圖標
var power_icons = {
    PowerType.RED_CRYSTAL: "💎",
    PowerType.BLUE_CRYSTAL: "💠",
    PowerType.GREEN_CRYSTAL: "🟢",
    PowerType.YELLOW_CRYSTAL: "🟡",
    PowerType.HEART: "❤️",
    PowerType.LIGHTNING: "⚡",
    PowerType.SHIELD: "🛡️"
}

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    # 15 秒後自動移除
    var timer = get_tree().create_timer(15.0)
    if timer:
        timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
    # 向下移動
    position.y += speed * delta
    
    # 旋轉
    rotation += rotation_speed * delta
    
    # 超出螢幕移除
    if position.y > get_viewport_rect().size.y + 50:
        queue_free()

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        apply_powerup(area)
        queue_free()

func apply_powerup(player: Node) -> void:
    var weapon_system = get_node_or_null("/root/Game/WeaponSystem")
    var game_manager = get_node_or_null("/root/Main")
    
    match power_type:
        PowerType.RED_CRYSTAL:
            if weapon_system:
                weapon_system.upgrade_weapon(1)
            print("[PowerUp] 紅水晶 - 武器升級 | Red Crystal - Weapon Up")
        
        PowerType.BLUE_CRYSTAL:
            if weapon_system:
                weapon_system.switch_weapon(WeaponSystem.WeaponType.LASER)
            print("[PowerUp] 藍水晶 - 激光武器 | Blue Crystal - Laser")
        
        PowerType.GREEN_CRYSTAL:
            if weapon_system:
                weapon_system.add_wingman()
            print("[PowerUp] 綠水晶 - 僚機 +1 | Green Crystal - Wingman")
        
        PowerType.YELLOW_CRYSTAL:
            if weapon_system:
                weapon_system.add_bomb(1)
            print("[PowerUp] 黃水晶 - 炸彈 +1 | Yellow Crystal - Bomb")
        
        PowerType.HEART:
            if game_manager:
                game_manager.lives += 1
                game_manager.lives_changed.emit(game_manager.lives)
            print("[PowerUp] 紅心 - 生命 +1 | Heart - Life +1")
        
        PowerType.LIGHTNING:
            if player.has_method("set_speed"):
                player.set_speed(player.speed * 1.5)
            print("[PowerUp] 閃電 - 速度提升 | Lightning - Speed Boost")
        
        PowerType.SHIELD:
            if player.has_method("start_invincibility"):
                player.start_invincibility(5.0)
            print("[PowerUp] 護盾 - 無敵 5 秒 | Shield - Invincible 5s")
