extends Node

## 遊戲管理器 - 控制遊戲流程、分數、生命等
## Game Manager - Controls game flow, score, lives, etc.

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal level_changed(new_level: int)
signal game_over
signal game_won

var score: int = 0
var lives: int = 3
var current_level: int = 1
var is_paused: bool = false
var is_game_over: bool = false

# 玩家場景引用
var player_node: Node = null

func _ready() -> void:
	add_to_group("game_manager")
	print("[Game Manager] 初始化完成 | Initialized")

func _process(_delta: float) -> void:
	# 檢測暫停
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

## 開始新遊戲
func start_new_game() -> void:
	score = 0
	lives = 3
	current_level = 1
	is_paused = false
	is_game_over = false
	
	score_changed.emit(score)
	lives_changed.emit(lives)
	level_changed.emit(current_level)
	
	print("[Game Manager] 新遊戲開始 | New Game Started")

## 增加分數
func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

## 失去生命
func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	
	if lives <= 0:
		trigger_game_over()

## 觸發遊戲結束
func trigger_game_over() -> void:
	is_game_over = true
	game_over.emit()
	print("[Game Manager] 遊戲結束 | Game Over")

## 完成關卡
func complete_level() -> void:
	current_level += 1
	level_changed.emit(current_level)
	
	if current_level > 5:
		game_won.emit()
		print("[Game Manager] 遊戲通關 | Game Won!")
	else:
		print("[Game Manager] 關卡 %d 完成 | Level %d Complete" % [current_level - 1, current_level - 1])

## 切換暫停狀態
func toggle_pause() -> void:
	if is_game_over:
		return
	
	is_paused = !is_paused
	get_tree().paused = is_paused
	print("[Game Manager] 暫停狀態：%s" % ("暫停" if is_paused else "繼續"))

## 設置玩家引用
func set_player(player: Node) -> void:
	player_node = player

## 獲取玩家
func get_player() -> Node:
	return player_node
