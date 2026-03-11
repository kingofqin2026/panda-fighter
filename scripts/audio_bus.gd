extends Node

## 音頻總線配置
## Audio Bus Configuration

# 創建音頻總線：Master, SFX, BGM

func _ready() -> void:
    setup_audio_buses()
    print("[Audio] 音頻總線配置完成 | Audio Bus Configured")

func setup_audio_buses() -> void:
    # Master 總線 (索引 0 - 默認存在)
    
    # 創建 SFX 總線
    var sfx_bus_idx = AudioServer.get_bus_index("SFX")
    if sfx_bus_idx == -1:
        AudioServer.add_bus()
        sfx_bus_idx = AudioServer.get_bus_count() - 1
        AudioServer.set_bus_name(sfx_bus_idx, "SFX")
        AudioServer.set_bus_send(sfx_bus_idx, "Master")
    
    # 創建 BGM 總線
    var bgm_bus_idx = AudioServer.get_bus_index("BGM")
    if bgm_bus_idx == -1:
        AudioServer.add_bus()
        bgm_bus_idx = AudioServer.get_bus_count() - 1
        AudioServer.set_bus_name(bgm_bus_idx, "BGM")
        AudioServer.set_bus_send(bgm_bus_idx, "Master")
    
    # 設置默認音量
    AudioServer.set_bus_volume_db(0, linear_to_db(1.0))  # Master
    AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(1.0))  # SFX
    AudioServer.set_bus_volume_db(bgm_bus_idx, linear_to_db(0.7))  # BGM
    
    print("[Audio] 總線配置：Master, SFX, BGM | Bus Config: Master, SFX, BGM")
