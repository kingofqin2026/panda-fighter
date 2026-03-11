extends Node

## 雷電風格音頻管理器
## Raiden-style Audio Manager

# 音效庫
var sfx_library = {
    # 武器音效
    "shoot_normal": "res://assets/audio/sfx/shoot_normal.wav",
    "shoot_laser": "res://assets/audio/sfx/shoot_laser.wav",
    "shoot_missile": "res://assets/audio/sfx/shoot_missile.wav",
    "shoot_spread": "res://assets/audio/sfx/shoot_spread.wav",
    "shoot_plasma": "res://assets/audio/sfx/shoot_plasma.wav",
    
    # 炸彈音效
    "bomb_use": "res://assets/audio/sfx/bomb_use.wav",
    "bomb_explode": "res://assets/audio/sfx/bomb_explode.wav",
    
    # 道具音效
    "powerup_collect": "res://assets/audio/sfx/powerup_collect.wav",
    "powerup_weapon": "res://assets/audio/sfx/powerup_weapon.wav",
    "powerup_bomb": "res://assets/audio/sfx/powerup_bomb.wav",
    "powerup_wingman": "res://assets/audio/sfx/powerup_wingman.wav",
    "powerup_heart": "res://assets/audio/sfx/powerup_heart.wav",
    
    # 連擊音效
    "combo_10": "res://assets/audio/sfx/combo_10.wav",
    "combo_20": "res://assets/audio/sfx/combo_20.wav",
    "combo_50": "res://assets/audio/sfx/combo_50.wav",
    "combo_100": "res://assets/audio/sfx/combo_100.wav",
    "combo_broken": "res://assets/audio/sfx/combo_broken.wav",
    
    # 玩家音效
    "player_hit": "res://assets/audio/sfx/player_hit.wav",
    "player_die": "res://assets/audio/sfx/player_die.wav",
    
    # 敵人音效
    "enemy_hit": "res://assets/audio/sfx/enemy_hit.wav",
    "enemy_explode": "res://assets/audio/sfx/enemy_explode.wav",
    "boss_appear": "res://assets/audio/sfx/boss_appear.wav",
    "boss_hit": "res://assets/audio/sfx/boss_hit.wav",
    "boss_die": "res://assets/audio/sfx/boss_die.wav",
    
    # UI 音效
    "ui_select": "res://assets/audio/sfx/ui_select.wav",
    "ui_confirm": "res://assets/audio/sfx/ui_confirm.wav",
    "ui_game_over": "res://assets/audio/sfx/ui_game_over.wav",
}

# 背景音樂
var bgm_library = {
    "title": "res://assets/audio/bgm/title.ogg",
    "stage1": "res://assets/audio/bgm/stage1.ogg",
    "stage2": "res://assets/audio/bgm/stage2.ogg",
    "stage3": "res://assets/audio/bgm/stage3.ogg",
    "stage4": "res://assets/audio/bgm/stage4.ogg",
    "stage5": "res://assets/audio/bgm/stage5.ogg",
    "boss": "res://assets/audio/bgm/boss.ogg",
    "game_over": "res://assets/audio/bgm/game_over.ogg",
    "result": "res://assets/audio/bgm/result.ogg",
}

# 音頻播放器
var sfx_players: Dictionary = {}
var bgm_player: AudioStreamPlayer
var current_bgm: String = ""

# 音量設置
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var bgm_volume: float = 0.7

# 音效池（用於重複播放）
var sfx_pool_size: int = 10

func _ready() -> void:
    add_to_group("audio_manager")
    
    # 創建 BGM 播放器
    bgm_player = AudioStreamPlayer.new()
    bgm_player.bus = "BGM"
    add_child(bgm_player)
    bgm_player.volume_db = linear_to_db(bgm_volume)
    
    # 預加載常用音效
    preload_common_sfx()
    
    print("[Audio] 音頻管理器初始化 | Audio Manager Initialized")

## 預加載常用音效
func preload_common_sfx() -> void:
    var common_sfx = ["shoot_normal", "enemy_explode", "powerup_collect", "bomb_use"]
    for sfx_name in common_sfx:
        if sfx_library.has(sfx_name):
            load_sfx(sfx_name)

## 加載音效
func load_sfx(sfx_name: String) -> AudioStream:
    if not sfx_library.has(sfx_name):
        print("[Audio] 音效不存在：%s | SFX not found: %s" % sfx_name)
        return null
    
    var path = sfx_library[sfx_name]
    var stream = load(path)
    if stream:
        sfx_players[sfx_name] = stream
        print("[Audio] 已加載：%s | Loaded: %s" % [sfx_name, sfx_name])
    else:
        print("[Audio] 加載失敗：%s | Load failed: %s" % sfx_name)
    return stream

## 播放音效
func play_sfx(sfx_name: String, volume_scale: float = 1.0) -> void:
    if not sfx_library.has(sfx_name):
        return
    
    # 如果已加載，直接播放
    if sfx_players.has(sfx_name):
        var player = AudioStreamPlayer.new()
        player.stream = sfx_players[sfx_name]
        player.bus = "SFX"
        player.volume_db = linear_to_db(sfx_volume * volume_scale)
        add_child(player)
        player.play()
        
        # 播放完畢後自動移除
        player.finished.connect(func(): player.queue_free())
    else:
        # 未加載則即時加載播放
        var stream = load_sfx(sfx_name)
        if stream:
            play_sfx(sfx_name, volume_scale)

## 播放背景音樂
func play_bgm(bgm_name: String, fade_in: float = 1.0) -> void:
    if not bgm_library.has(bgm_name):
        print("[Audio] BGM 不存在：%s | BGM not found: %s" % bgm_name)
        return
    
    if current_bgm == bgm_name and bgm_player.playing:
        return  # 已在播放
    
    current_bgm = bgm_name
    var path = bgm_library[bgm_name]
    var stream = load(path)
    
    if stream:
        bgm_player.stream = stream
        bgm_player.volume_db = linear_to_db(bgm_volume)
        bgm_player.play()
        print("[Audio] 播放 BGM: %s | Playing BGM: %s" % bgm_name)

## 停止背景音樂
func stop_bgm(fade_out: float = 1.0) -> void:
    if bgm_player.playing:
        bgm_player.stop()
        current_bgm = ""
        print("[Audio] 停止 BGM | BGM Stopped")

## 暫停背景音樂
func pause_bgm(paused: bool) -> void:
    bgm_player.stream_paused = paused

## 設置音量
func set_master_volume(volume: float) -> void:
    master_volume = clamp(volume, 0.0, 1.0)
    AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))

func set_sfx_volume(volume: float) -> void:
    sfx_volume = clamp(volume, 0.0, 1.0)

func set_bgm_volume(volume: float) -> void:
    bgm_volume = clamp(volume, 0.0, 1.0)
    if bgm_player.playing:
        bgm_player.volume_db = linear_to_db(bgm_volume)

## 音效快捷方式

### 武器音效
func play_shoot(weapon_type: int = 0) -> void:
    var sfx_names = ["shoot_normal", "shoot_laser", "shoot_missile", "shoot_spread", "shoot_plasma"]
    var sfx_name = sfx_names[clamp(weapon_type, 0, sfx_names.size() - 1)]
    play_sfx(sfx_name, 0.3)

### 炸彈音效
func play_bomb() -> void:
    play_sfx("bomb_use", 1.0)
    await get_tree().create_timer(0.3).timeout
    play_sfx("bomb_explode", 0.8)

### 道具收集音效
func play_powerup(powerup_type: String) -> void:
    var sfx_name = "powerup_collect"
    match powerup_type:
        "red_crystal", "blue_crystal":
            sfx_name = "powerup_weapon"
        "yellow_crystal":
            sfx_name = "powerup_bomb"
        "green_crystal":
            sfx_name = "powerup_wingman"
        "heart":
            sfx_name = "powerup_heart"
    play_sfx(sfx_name, 0.5)

### 連擊音效
func play_combo(combo: int) -> void:
    if combo >= 100:
        play_sfx("combo_100", 0.6)
    elif combo >= 50:
        play_sfx("combo_50", 0.5)
    elif combo >= 20:
        play_sfx("combo_20", 0.4)
    elif combo >= 10:
        play_sfx("combo_10", 0.3)

func play_combo_broken() -> void:
    play_sfx("combo_broken", 0.4)

### 玩家音效
func play_player_hit() -> void:
    play_sfx("player_hit", 0.7)

func play_player_die() -> void:
    play_sfx("player_die", 1.0)

### 敵人音效
func play_enemy_hit() -> void:
    play_sfx("enemy_hit", 0.3)

func play_enemy_explode() -> void:
    play_sfx("enemy_explode", 0.5)

func play_boss_appear() -> void:
    play_sfx("boss_appear", 0.8)

func play_boss_hit() -> void:
    play_sfx("boss_hit", 0.4)

func play_boss_die() -> void:
    play_sfx("boss_die", 1.0)

### UI 音效
func play_ui_select() -> void:
    play_sfx("ui_select", 0.4)

func play_ui_confirm() -> void:
    play_sfx("ui_confirm", 0.5)

func play_game_over() -> void:
    play_sfx("ui_game_over", 0.8)
    play_bgm("game_over")
