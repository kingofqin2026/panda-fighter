extends "res://scripts/player_raiden.gd"

## 雷電風格玩家 - 音頻增強版
## Raiden-style Player - Audio Enhanced

var audio_manager: Node

func _ready() -> void:
    super._ready()
    
    # 獲取音頻管理器
    audio_manager = get_node_or_null("/root/Game/AudioManager")
    
    # 連接信號到音頻
    player_hit.connect(_on_player_hit)
    player_died.connect(_on_player_died)
    bomb_count_changed.connect(_on_bomb_used)
    
    print("[Player] 音頻增強版就緒 | Audio Enhanced Ready")

func shoot() -> void:
    super.shoot()
    
    # 播放射擊音效
    if audio_manager and audio_manager.has_method("play_shoot"):
        audio_manager.play_shoot(0)  # 0 = NORMAL weapon

func use_bomb() -> void:
    if bomb_count > 0:
        # 播放炸彈音效
        if audio_manager and audio_manager.has_method("play_bomb"):
            audio_manager.play_bomb()
        
        super.use_bomb()

func _on_player_hit() -> void:
    if audio_manager and audio_manager.has_method("play_player_hit"):
        audio_manager.play_player_hit()

func _on_player_died() -> void:
    if audio_manager and audio_manager.has_method("play_player_die"):
        audio_manager.play_player_die()

func _on_bomb_used(_count: int) -> void:
    # 炸彈使用音效已在 use_bomb 中播放
    pass
