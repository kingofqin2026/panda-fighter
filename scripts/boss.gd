extends Area2D

## Boss 腳本 - 機械恐龍
## Boss Script - Mechanical Dinosaur

@export var health: int = 100
@export var max_health: int = 100
@export var phase: int = 1

var attack_pattern: String = "fire"
var attack_timer: float = 0.0
var attack_interval: float = 2.0
var move_direction: float = 1.0
var score_value: int = 5000

signal boss_defeated
signal phase_changed(new_phase: int)

func _ready() -> void:
    add_to_group("boss")
    add_to_group("enemies")

func _physics_process(delta: float) -> void:
    # 左右移動
    position.x += move_direction * 50.0 * delta
    
    # 邊界反彈
    var viewport_width = get_viewport_rect().size.x
    if position.x > viewport_width - 64 or position.x < 64:
        move_direction *= -1
    
    # 攻擊計時
    attack_timer += delta
    if attack_timer >= attack_interval:
        attack_timer = 0.0
        perform_attack()
    
    # 階段轉換
    check_phase()

func perform_attack() -> void:
    match phase:
        1:
            # 階段 1: 噴火攻擊
            attack_pattern = "fire"
            attack_interval = 2.0
        2:
            # 階段 2: 發射導彈
            attack_pattern = "missile"
            attack_interval = 1.5
        3:
            # 階段 3: 狂暴模式
            attack_pattern = "spread"
            attack_interval = 0.8

func check_phase() -> void:
    var old_phase = phase
    
    if health <= max_health * 0.33:
        phase = 3
    elif health <= max_health * 0.66:
        phase = 2
    
    if phase != old_phase:
        phase_changed.emit(phase)

func take_damage(amount: int) -> void:
    health -= amount
    
    if health <= 0:
        die()

func die() -> void:
    boss_defeated.emit()
    
    var game_manager = get_node_or_null("/root/Main")
    if game_manager:
        game_manager.add_score(score_value)
        game_manager.complete_level()
    
    queue_free()
