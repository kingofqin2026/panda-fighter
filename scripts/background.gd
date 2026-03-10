extends ParallaxBackground

## 背景滾動腳本
## Background Scrolling Script

@export var scroll_speed: float = 50.0
@export var parallax_layers: Array[ParallaxLayer] = []

func _ready() -> void:
    # 自動檢測子節點中的 ParallaxLayer
    if parallax_layers.is_empty():
        for child in get_children():
            if child is ParallaxLayer:
                parallax_layers.append(child)

func _process(delta: float) -> void:
    # 滾動背景
    for layer in parallax_layers:
        layer.scroll_offset.y += scroll_speed * delta * layer.motion_scale.y
