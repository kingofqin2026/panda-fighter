extends Area2D

## 子彈腳本
## Bullet Script

@export var speed: float = 500.0
@export var damage: int = 1

var power: int = 1
var direction: Vector2 = Vector2.UP

func _ready() -> void:
	# 設置碰撞
	collision_layer = 4  # 子彈層
	collision_mask = 2   # 敵人層
	
	# 連接信號
	area_entered.connect(_on_area_entered)
	
	# 10 秒後自動移除
	var timer = get_tree().create_timer(10.0)
	if timer:
		timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# 超出螢幕移除
	if position.y < -50 or position.y > get_viewport_rect().size.y + 50:
		queue_free()
	if position.x < -50 or position.x > get_viewport_rect().size.x + 50:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	# 檢查是否擊中敵人
	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			area.take_damage(damage * power)
		
		# 播放擊中效果（待實現）
		queue_free()
