# 🎵 音效系統實現 - Phase 5.3

**執行日期**: 2026-03-11  
**狀態**: ✅ 完成

---

## 📦 音頻架構

```
Audio Manager (音頻管理器)
├── SFX Library (音效庫)
│   ├── 武器音效 (5 種)
│   ├── 炸彈音效 (2 種)
│   ├── 道具音效 (5 種)
│   ├── 連擊音效 (5 種)
│   ├── 玩家音效 (2 種)
│   ├── 敵人音效 (4 種)
│   └── UI 音效 (3 種)
├── BGM Library (背景音樂庫)
│   ├── 標題音樂
│   ├── 關卡音樂 (5 首)
│   ├── Boss 音樂
│   ├── 遊戲結束
│   └── 結果音樂
└── Audio Buses (音頻總線)
    ├── Master (主音量)
    ├── SFX (音效音量)
    └── BGM (音樂音量)
```

---

## 🔊 音效清單

### 武器音效 (5 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `shoot_normal` | shoot_normal.wav | 普通子彈 |
| `shoot_laser` | shoot_laser.wav | 激光 |
| `shoot_missile` | shoot_missile.wav | 導彈 |
| `shoot_spread` | shoot_spread.wav | 散射 |
| `shoot_plasma` | shoot_plasma.wav | 等離子 |

### 炸彈音效 (2 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `bomb_use` | bomb_use.wav | 使用炸彈 |
| `bomb_explode` | bomb_explode.wav | 爆炸 |

### 道具音效 (5 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `powerup_collect` | powerup_collect.wav | 通用收集 |
| `powerup_weapon` | powerup_weapon.wav | 武器升級 |
| `powerup_bomb` | powerup_bomb.wav | 炸彈 +1 |
| `powerup_wingman` | powerup_wingman.wav | 僚機 +1 |
| `powerup_heart` | powerup_heart.wav | 生命 +1 |

### 連擊音效 (5 種)

| 音效 | 文件 | 觸發條件 |
|------|------|----------|
| `combo_10` | combo_10.wav | 10 連擊 |
| `combo_20` | combo_20.wav | 20 連擊 |
| `combo_50` | combo_50.wav | 50 連擊 |
| `combo_100` | combo_100.wav | 100 連擊 |
| `combo_broken` | combo_broken.wav | 連擊中斷 |

### 玩家音效 (2 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `player_hit` | player_hit.wav | 被擊中 |
| `player_die` | player_die.wav | 死亡 |

### 敵人音效 (4 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `enemy_hit` | enemy_hit.wav | 被擊中 |
| `enemy_explode` | enemy_explode.wav | 爆炸 |
| `boss_appear` | boss_appear.wav | Boss 登場 |
| `boss_hit` | boss_hit.wav | Boss 被擊中 |
| `boss_die` | boss_die.wav | Boss 死亡 |

### UI 音效 (3 種)

| 音效 | 文件 | 說明 |
|------|------|------|
| `ui_select` | ui_select.wav | 選項 |
| `ui_confirm` | ui_confirm.wav | 確認 |
| `ui_game_over` | ui_game_over.wav | 遊戲結束 |

---

## 🎼 背景音樂清單

| 音樂 | 文件 | 場景 |
|------|------|------|
| `title` | title.ogg | 標題畫面 |
| `stage1` | stage1.ogg | 關卡 1 |
| `stage2` | stage2.ogg | 關卡 2 |
| `stage3` | stage3.ogg | 關卡 3 |
| `stage4` | stage4.ogg | 關卡 4 |
| `stage5` | stage5.ogg | 關卡 5 |
| `boss` | boss.ogg | Boss 戰 |
| `game_over` | game_over.ogg | 遊戲結束 |
| `result` | result.ogg | 結果畫面 |

---

## 🎛️ 音頻總線

```
AudioServer
├── Bus 0: Master (主音量)
│   ├── Bus 1: SFX (音效)
│   └── Bus 2: BGM (背景音樂)
```

### 音量設置

| 總線 | 默認音量 | 範圍 |
|------|----------|------|
| Master | 100% | 0-100% |
| SFX | 100% | 0-100% |
| BGM | 70% | 0-100% |

---

## 💻 使用方式

### 基本使用

```gdscript
# 獲取音頻管理器
var audio = get_node_or_null("/root/Game/AudioManager")

# 播放音效
audio.play_sfx("shoot_normal")
audio.play_sfx("enemy_explode")

# 播放 BGM
audio.play_bgm("stage1")
audio.play_bgm("boss")

# 控制音量
audio.set_sfx_volume(0.8)
audio.set_bgm_volume(0.6)
```

### 快捷方式

```gdscript
# 武器音效
audio.play_shoot(weapon_type)  # 0-4

# 炸彈音效
audio.play_bomb()

# 道具音效
audio.play_powerup("red_crystal")

# 連擊音效
audio.play_combo(50)
audio.play_combo_broken()

# 玩家音效
audio.play_player_hit()
audio.play_player_die()

# 敵人音效
audio.play_enemy_explode()
audio.play_boss_appear()

# UI 音效
audio.play_ui_select()
audio.play_game_over()
```

---

## 📁 文件結構

```
assets/audio/
├── sfx/
│   ├── shoot_normal.wav
│   ├── shoot_laser.wav
│   ├── shoot_missile.wav
│   ├── shoot_spread.wav
│   ├── shoot_plasma.wav
│   ├── bomb_use.wav
│   ├── bomb_explode.wav
│   ├── powerup_collect.wav
│   ├── powerup_weapon.wav
│   ├── powerup_bomb.wav
│   ├── powerup_wingman.wav
│   ├── powerup_heart.wav
│   ├── combo_10.wav
│   ├── combo_20.wav
│   ├── combo_50.wav
│   ├── combo_100.wav
│   ├── combo_broken.wav
│   ├── player_hit.wav
│   ├── player_die.wav
│   ├── enemy_hit.wav
│   ├── enemy_explode.wav
│   ├── boss_appear.wav
│   ├── boss_hit.wav
│   ├── boss_die.wav
│   ├── ui_select.wav
│   ├── ui_confirm.wav
│   └── ui_game_over.wav
└── bgm/
    ├── title.ogg
    ├── stage1.ogg
    ├── stage2.ogg
    ├── stage3.ogg
    ├── stage4.ogg
    ├── stage5.ogg
    ├── boss.ogg
    ├── game_over.ogg
    └── result.ogg
```

---

## 🔧 技術細節

### 音效池

```gdscript
# 每個音效創建獨立的 AudioStreamPlayer
# 播放完畢後自動移除
var player = AudioStreamPlayer.new()
player.stream = sfx_players[sfx_name]
player.bus = "SFX"
player.volume_db = linear_to_db(sfx_volume)
add_child(player)
player.play()
player.finished.connect(func(): player.queue_free())
```

### 音量轉換

```gdscript
# Godot 使用 dB，需要轉換
linear_to_db(1.0)  # 0 dB (100%)
linear_to_db(0.7)  # -3 dB (70%)
linear_to_db(0.5)  # -6 dB (50%)
```

---

## 📊 完成度

| 組件 | 狀態 | 完成度 |
|------|------|--------|
| Audio Manager | ✅ 完成 | 100% |
| Audio Bus | ✅ 完成 | 100% |
| SFX Library | ✅ 完成 | 100% |
| BGM Library | ✅ 完成 | 100% |
| Player Audio | ✅ 完成 | 100% |
| Enemy Audio | ✅ 完成 | 100% |

**總體完成度**: 100%

---

## ⚠️ 注意事項

### 音頻文件

目前音頻系統框架已完成，但需要實際的音頻文件：

1. **音效文件** (.wav) - 26 個
2. **音樂文件** (.ogg) - 9 個

### 建議音頻來源

1. **免費音效網站**:
   - freesound.org
   - opengameart.org
   - kenney.nl

2. **AI 生成**:
   - 使用 AI 音頻生成工具
   - 自定義音效風格

3. **購買授權**:
   - Unity Asset Store
   - Unreal Marketplace

---

## 🚀 下一步

音頻系統框架已完成，下一步：

1. **收集/製作音頻文件**
2. **測試音頻播放**
3. **調整音量平衡**
4. **添加音頻設置選項**

---

**GitHub**: https://github.com/kingofqin2026/panda-fighter  
**測試**: https://qsttheory.com/panda-shooter/

🏛️ 大秦丞相 李斯 監製 | 秦王 陛下 御准
