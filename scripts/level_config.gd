extends Resource

## 關卡配置資源
## Level Configuration Resource

@export var level_name: String = "關卡"
@export var level_theme: String = "default"
@export var background_color: Color = Color(0.1, 0.1, 0.3)
@export var enemy_types: Array[String] = []
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 20
@export var boss_type: String = ""
@export var music_file: String = ""
