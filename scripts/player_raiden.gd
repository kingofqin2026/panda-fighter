extends Area2D

## 雷電風格玩家控制器
## Raiden-style Player Controller

@export var speed: float = 300.0
@export var health: int = 3
@export var bullet_scene: PackedScene
@export var wingman_scene: PackedScene

var can_shoot: bool = true
var shoot_delay: float = 0.15
var is_invincible: bool = false
var bomb_count: int = 3
var weapon_level: int = 1

# 信號
signal player_hit
signal player_died
signal bomb_count_changed(count: int)
signal weapon_level_changed(level: int)

# 僚機列表
var wingmen: Array = []

func _ready() -> void:
    add_to_group("player")
    
    # 連接到遊戲管理器
    var game_manager = get_node_or_null("/root/Main")
    if game_manager:
        game_manager.set_player(self)
    
    # 設置射擊計時器
    var shoot_timer = $ShootTimer
    if shoot_timer:
        shoot_timer.timeout.connect(_on_shoot_timer_timeout)
        shoot_timer.start(shoot_delay)
    
    print("[Player] 熊貓戰機已就緒 | Panda Fighter Ready")

func _physics_process(delta: float) -> void:
    if is_invincible:
        return
    
    # 獲取輸入
    var input_direction = Vector2.ZERO
    
    if Input.is_action_pressed("move_right"):
        input_direction.x += 1
    if Input.is_action_pressed("move_left"):
        input_direction.x -= 1
    if Input.is_action_pressed("move_down"):
        input_direction.y += 1
    if Input.is_action_pressed("move_up"):
        input_direction.y -= 1
    
    # 移動
    if input_direction != Vector2.ZERO:
        position += input_direction.normalized() * speed * delta
    
    # 邊界限制
    var viewport_size = get_viewport_rect().size
    position.x = clamp(position.x, 16, viewport_size.x - 16)
    position.y = clamp(position.y, 16, viewport_size.y - 16)
    
    # 自動射擊
    if can_shoot and not is_invincible:
        shoot()
    
    # 炸彈（空格鍵）
    if Input.is_action_just_pressed("shoot"):
        use_bomb()

func shoot() -> void:
    if not bullet_scene:
        return
    
    # 主武器射擊
    var bullet = bullet_scene.instantiate()
    if bullet:
        bullet.position = position
        bullet.power = weapon_level
        get_tree().current_scene.add_child(bullet)
        can_shoot = false

func _on_shoot_timer_timeout() -> void:
    can_shoot = true

## 受到傷害
func take_damage(amount: int) -> void:
    if is_invincible:
        return
    
    health -= amount
    player_hit.emit()
    
    # 短暫無敵
    start_invincibility(1.0)
    
    if health <= 0:
        player_died.emit()
        die()

## 開始無敵狀態
func start_invincibility(duration: float) -> void:
    is_invincible = true
    visible = false
    
    await get_tree().create_timer(duration).timeout
    
    is_invincible = false
    visible = true

## 死亡
func die() -> void:
    var game_manager = get_node_or_null("/root/Main")
    if game_manager:
        game_manager.lose_life()
    
    queue_free()

## 升級武器
func upgrade_weapon() -> void:
    weapon_level = min(weapon_level + 1, 5)
    weapon_level_changed.emit(weapon_level)
    print("[Player] 武器升級到等級 %d | Weapon upgraded to level %d" % [weapon_level, weapon_level])

## 使用炸彈
func use_bomb() -> void:
    if bomb_count > 0:
        bomb_count -= 1
        bomb_count_changed.emit(bomb_count)
        
        # 全屏攻擊
        var enemies = get_tree().get_nodes_in_group("enemies")
        for enemy in enemies:
            if enemy.has_method("take_damage"):
                enemy.take_damage(100)
        
        # 無敵短暫時間
        start_invincibility(0.5)
        
        print("[Player] 炸彈！剩餘 %d | Bomb! Remaining: %d" % [bomb_count, bomb_count])

## 添加炸彈
func add_bomb(count: int = 1) -> void:
    bomb_count += count
    bomb_count_changed.emit(bomb_count)

## 添加僚機
func add_wingman() -> void:
    if wingman_scene and wingmen.size() < 4:
        var wingman = wingman_scene.instantiate()
        if wingman:
            # 設置跟隨目標
            wingman.set_target(self)
            
            # 設置偏移位置
            var offset_index = wingmen.size()
            var offset = Vector2(-40 - (offset_index * 20), 20)
            if offset_index % 2 == 1:
                offset.x = 40 + (offset_index * 20)
            wingman.set_offset(offset)
            
            get_tree().current_scene.add_child(wingman)
            wingmen.append(wingman)
            
            print("[Player] 僚機 +1 | Wingman +1")

## 設置速度
func set_speed(new_speed: float) -> void:
    speed = new_speed
