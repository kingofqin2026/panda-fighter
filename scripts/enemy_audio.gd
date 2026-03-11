extends "res://scripts/enemy_raiden.gd"

## 雷電風格敵機 - 音頻增強版
## Raiden-style Enemy - Audio Enhanced

var audio_manager: Node

func _ready() -> void:
    super._ready()
    
    # 獲取音頻管理器
    audio_manager = get_node_or_null("/root/Game/AudioManager")

func take_damage(amount: int) -> void:
    super.take_damage(amount)
    
    # 播放被擊中音效
    if audio_manager and audio_manager.has_method("play_enemy_hit"):
        audio_manager.play_enemy_hit()

func die() -> void:
    # 播放爆炸音效
    if audio_manager and audio_manager.has_method("play_enemy_explode"):
        audio_manager.play_enemy_explode()
    
    super.die()
