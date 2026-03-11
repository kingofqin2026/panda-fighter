# 🐼 熊貓戰機 (Panda Fighter)

> Godot 4.x Web 直向射擊遊戲

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Godot](https://img.shields.io/badge/Godot-4.x-478cbf.svg)
![Platform](https://img.shields.io/badge/platform-Web-lightgrey.svg)

## 🎮 遊戲介紹

**熊貓戰機** 是一款可愛風格的直向卷軸射擊遊戲，玩家控制熊貓飛行員駕駛戰機，穿越 5 個關卡，最終挑戰機械恐龍 Boss！

### 特色
- 🐼 可愛 Pixel Art 熊貓主角
- 🎯 5 個精心設計的關卡
- 🦕 三階段機械恐龍 Boss 戰
- 🎨 明亮可愛的畫風
- 🌐 Web 瀏覽器即可遊玩

## 🎯 遊戲玩法

- **移動**: 鍵盤方向鍵 / WASD 或 觸控拖曳
- **射擊**: 自動射擊
- **特殊攻擊**: 空格鍵釋放熊貓氣場

## 🗺️ 關卡列表

| 關卡 | 名稱 | 主題 | Boss |
|------|------|------|------|
| 1 | 竹林訓練場 | 綠色竹林 | 蜜蜂轟炸機 |
| 2 | 雲層巡航 | 白色雲朵 | 貓頭鷹護衛 |
| 3 | 山谷突襲 | 峽谷地形 | 老鷹精英 |
| 4 | 工廠入侵 | 機械工廠 | 機械蜘蛛 |
| 5 | 恐龍巢穴 | 火山巢穴 | 機械恐龍 |

## 🛠️ 開發環境

### 需求
- Godot 4.x
- Git

### 安裝步驟

```bash
# 1. 克隆倉庫
git clone https://github.com/kingofqin2026/panda-fighter.git
cd panda-fighter

# 2. 用 Godot 4.x 打開項目
# 在 Godot 中選擇 project.godot 文件

# 3. 運行遊戲
# 點擊 Godot 的運行按鈕 (F5)

# 4. 導出 Web 版本
# 項目 > 導出 > Web > 導出項目
```

## 📁 項目結構

```
panda-fighter/
├── project.godot          # Godot 項目配置
├── README.md              # 本文件
├── LICENSE                # MIT 許可證
├── scenes/                # 遊戲場景
│   ├── Main.tscn
│   ├── Player.tscn
│   ├── Enemy.tscn
│   └── Boss.tscn
├── scripts/               # GDScript 代碼
│   ├── player.gd
│   ├── enemy.gd
│   └── boss.gd
├── assets/                # 美術和音頻資源
│   ├── sprites/
│   ├── backgrounds/
│   └── audio/
└── levels/                # 關卡配置
    └── level_*.tres
```

## 🎨 美術資源

目前使用佔位符圖形，後續將替換為：
- Pixel Art 熊貓主角
- 5 種敵人類型
- 機械恐龍 Boss
- 5 個關卡背景

## 🎵 音頻資源

- 背景音樂 (BGM)
- 射擊音效
- 爆炸音效
- 道具收集音效

## 📅 開發時程

| 階段 | 內容 | 預計時間 | 狀態 |
|------|------|----------|------|
| 1 | 基礎框架 | 1-2 週 | ✅ 完成 |
| 2 | 敵人系統 | 1-2 週 | ✅ 完成 |
| 3 | 關卡設計 | 2 週 | ✅ 完成 |
| 4 | Boss 戰 | 1 週 | ✅ 完成 |
| 5.1 | 武器系統 | 1 週 | ✅ 完成 |
| 5.2 | 道具系統 | 1 週 | ✅ 完成 |
| 5.3 | 炸彈/僚機/連擊 | 1 週 | ✅ 完成 |
| 5.4 | 敵人升級 | 1 週 | ⏳ 進行中 |
| 5.5 | UI 升級 | 1 週 | ⏳ 待開始 |
| 5.6 | 美術音效 | 2 週 | ⏳ 待開始 |
| 6 | 優化測試 | 1 週 | ⏳ 待開始 |

**總計**: 10-12 週

---

## 🎮 雷電風格升級 (v2.0)

### 新增系統
- ✅ 多武器系統 (NORMAL/LASER/MISSILE/SPREAD/PLASMA)
- ✅ 武器升級 (1-5 級)
- ✅ 道具系統 (7 種水晶/道具)
- ✅ 炸彈系統 (全屏攻擊)
- ✅ 僚機系統 (最多 4 個)
- ✅ 連擊系統 (最高 5 倍分數)

### 遊戲玩法
- 收集紅水晶升級武器
- 收集藍水晶切換激光
- 收集綠水晶添加僚機
- 收集黃水晶添加炸彈
- 保持連擊獲得倍率
- 使用炸彈清屏救急

## 🌐 線上遊玩

遊戲完成後將在以下平台發布：
- [GitHub Pages](https://kingofqin2026.github.io/panda-fighter/)
- [QST Theory](https://qsttheory.com/games/panda-fighter/)

## 📝 許可證

本項目採用 MIT 許可證 - 詳見 [LICENSE](LICENSE) 文件

## 👨‍💻 開發者

- **策劃**: 秦王
- **開發**: 大秦丞相 李斯

## 🔗 相關連結

- [QST Theory](https://qsttheory.com)
- [開發計劃](開發計劃.md)
- [Godot Engine](https://godotengine.org/)

---

🏛️ 大秦丞相 李斯 監製 | 秦王 陛下 御准
