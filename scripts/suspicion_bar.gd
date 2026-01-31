extends Control

@onready var bar: ProgressBar = $ProgressBar

func update_color(percent_full: int) -> void:
	var style = bar.get_theme_stylebox("fill") as StyleBoxFlat
	if percent_full < 20:
		style.bg_color = Color.RED
	elif percent_full >= 20 and percent_full < 50:
		style.bg_color = Color.YELLOW
	elif percent_full >= 50:
		style.bg_color = Color.GREEN

func decrease_by(delta: float) -> void:
	bar.value = bar.value - delta
	if bar.value < 0:
		bar.value = 0
	update_color(bar.value)
	
func increase_by(delta: float) -> void:
	bar.value = bar.value + delta
	if bar.value > 100:
		bar.value = 100
	update_color(bar.value)
