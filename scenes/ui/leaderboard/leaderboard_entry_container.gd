class_name LeaderboardEntryContainer extends Control

@onready var highlight_background: ColorRect = $HighlightBackground
@onready var rank_num_label: Label = $MarginContainer/HBoxContainer/RankNumLabel
@onready var username_label: Label = $MarginContainer/HBoxContainer/UsernameLabel
@onready var time_label: Label = $MarginContainer/HBoxContainer/TimeLabel
@onready var rank_label: Label = $MarginContainer/HBoxContainer/RankLabel

func set_info(rank_num: int, username: String, time: float, is_curr_player: bool) -> void:
	rank_num_label.text = str(rank_num) + "."
	username_label.text = username
	time_label.text = Utils.format_time(time)
	highlight_background.visible = is_curr_player
