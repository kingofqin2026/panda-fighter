extends Area2D

## 僚機系統
## Wingman System

@export var follow_speed: float = 5.0
@export var offset: Vector2 = Vector2(-40, 20)
@export var fire_rate: float = 0.3
@export var bullet_scene: PackedScene

var target: Node2D = null
var can_shoot: bool = true
var weapon_level: int = 1

func _ready() -> void:
    add_to_group("wingmen")
    collision_layer = 4
    collision_mask = 0

func _process(delta: float) -> void:
    if target:
        # 跟隨玩家
        var target_pos = target.position + offset
        position = position.lerp(target_pos, follow_speed * delta)
        
        # 自動射擊
        if can_shoot and bullet_scene:
            shoot()

func set_target(new_target: Node2D) -> void:
    target = new_target

func set_offset(new_offset: Vector2) -> void:
    offset = new_offset

func shoot() -> void:
    if not bullet_scene or not target:
        return
    
    var bullet = bullet_scene.instantiate()
    if bullet:
        bullet.position = position
        bullet.power = weapon_level
        get_tree().current_scene.add_child(bullet)
        can_shoot = false
        
        var timer = get_tree().create_timer(fire_rate)
        if timer:
            timer.timeout.connect(func(): can_shoot = true)

func upgrade(level: int) -> void:
    weapon_level = level
    fire_rate = max(0.1, 0.3 - level * 0.05)
