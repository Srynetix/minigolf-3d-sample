extends CanvasLayer

const bar_red := preload("res://assets/bar_red.png")
const bar_green := preload("res://assets/bar_green.png")
const bar_yellow := preload("res://assets/bar_yellow.png")

onready var _shots := $Margin/Container/Shots as Label
onready var _power_bar := $Margin/Container/PowerBar as TextureProgress

func update_shots(value: int):
    _shots.text = 'Shots: %s' % value

func update_powerbar(value: int):
    _power_bar.texture_progress = bar_green
    if value > 70:
        _power_bar.texture_progress = bar_red
    elif value > 40:
        _power_bar.texture_progress = bar_yellow

    _power_bar.value = value