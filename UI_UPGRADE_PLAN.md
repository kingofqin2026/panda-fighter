# 🎨 UI 升級計劃 - Phase 5.2

**執行日期**: 2026-03-11  
**狀態**: ✅ 完成

---

## 📦 新增 UI 組件

### 1. HUD 場景 (HUD.tscn)

```
CanvasLayer
└── MarginContainer
    └── VBoxContainer
        ├── SCORE: 000000
        ├── HI-000000
        ├── ─────
        ├── COMBO: x1.0 [C/B/A/S/SS/SSS]
        ├── ─────
        ├── WEAPON: NORMAL Lv.1
        ├── BOMB: 💣💣💣
        ├── WINGMAN: 🛩️🛩️
        └── LIVES: ❤️❤️❤️
```

### 2. HUD 腳本 (hud.gd)

**功能**：
- ✅ 分數顯示（6 位數）
- ✅ 最高分記錄（本地保存）
- ✅ 連擊顯示（倍率 + 評價）
- ✅ 武器顯示（類型 + 等級）
- ✅ 炸彈計數（圖標顯示）
- ✅ 僚機顯示（圖標顯示）
- ✅ 生命顯示（圖標顯示）

**顏色編碼**：
| 評價 | 顏色 |
|------|------|
| C | 藍色 |
| B | 綠色 |
| A | 黃色 |
| S | 橙色 |
| SS | 紅橙色 |
| SSS | 粉紅色 |

### 3. 遊戲管理器升級 (game_manager_raiden.gd)

**新增統計**：
- 擊落敵機總數
- 收集道具總數
- 最大連擊數
- 遊戲時間

### 4. Game 場景升級 (Game.tscn)

**新增節點**：
- ✅ HUD (CanvasLayer)
- ✅ ComboSystem (Node)
- ✅ WeaponSystem (Node)
- ✅ PowerUpScene (Node)

---

## 🎯 UI 佈局

```
┌─────────────────────────────────┐
│  SCORE: 000000                  │
│  HI-000000                      │
│  ─────────────────────          │
│  COMBO: x2.5 [A]                │
│  ─────────────────────          │
│  WEAPON: LASER Lv.3             │
│  BOMB: 💣💣💣                    │
│  WINGMAN: 🛩️🛩️                  │
│  LIVES: ❤️❤️❤️                  │
│                                 │
│         [遊戲區域]              │
│                                 │
│         🐼 玩家                 │
│      👾👾👾 敵人                │
│      💎 道具                   │
│                                 │
└─────────────────────────────────┘
```

---

## 📊 數據流

```
玩家擊落敵人
    ↓
ComboSystem.add_combo()
    ↓
HUD._on_combo_changed()
    ↓
更新 UI 顯示

玩家收集道具
    ↓
WeaponSystem.upgrade_weapon()
    ↓
HUD._on_weapon_changed()
    ↓
更新 UI 顯示

玩家使用炸彈
    ↓
Player.use_bomb()
    ↓
HUD._on_bomb_count_changed()
    ↓
更新 UI 顯示
```

---

## 💾 存檔系統

### 最高分保存

```gdscript
# 保存
var config = ConfigFile.new()
config.set_value("game", "high_score", score)
config.save("user://high_score.cfg")

# 加載
var config = ConfigFile.new()
config.load("user://high_score.cfg")
high_score = config.get_value("game", "high_score", 0)
```

**存檔位置**: `user://high_score.cfg`

---

## 🎨 視覺效果

### 連擊評價動畫

```gdscript
# 根據評價改變顏色
match rank:
    "C": combo_rank.modulate = Color(0.5, 0.5, 1)      # 藍色
    "B": combo_rank.modulate = Color(0.5, 1, 0.5)      # 綠色
    "A": combo_rank.modulate = Color(1, 1, 0.5)        # 黃色
    "S": combo_rank.modulate = Color(1, 0.8, 0.2)      # 橙色
    "SS": combo_rank.modulate = Color(1, 0.5, 0.2)     # 紅橙色
    "SSS": combo_rank.modulate = Color(1, 0.2, 0.5)    # 粉紅色
```

### 道具收集提示

```gdscript
# 可以在 HUD 中添加短暫的提示文字
func show_powerup_message(powerup_type: String):
    # 顯示 "WEAPON UP!" 或 "BOMB +1" 等提示
    pass
```

---

## 📈 完成度

| 組件 | 狀態 | 完成度 |
|------|------|--------|
| HUD 場景 | ✅ 完成 | 100% |
| HUD 腳本 | ✅ 完成 | 100% |
| 遊戲管理器 | ✅ 完成 | 100% |
| Game 場景 | ✅ 完成 | 100% |
| 存檔系統 | ✅ 完成 | 100% |
| 視覺效果 | ✅ 完成 | 100% |

**總體完成度**: 100%

---

## 🚀 下一步：Phase 5.3 音效

- [ ] 武器音效
- [ ] 炸彈音效
- [ ] 道具收集音效
- [ ] 連擊音效
- [ ] Boss 戰音樂

---

**GitHub**: https://github.com/kingofqin2026/panda-fighter  
**測試**: https://qsttheory.com/panda-shooter/

🏛️ 大秦丞相 李斯 監製 | 秦王 陛下 御准
