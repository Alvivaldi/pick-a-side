extends Node2D
var score_a:int=0
var score_b:int=0

@onready var label_score_a:Label=$VoteA
@onready var label_score_b:Label=$VoteB
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_vote():
	show()

func _on_camp_a_pressed() -> void:
	score_a+=1
	label_score_a.text=str(score_a)


func _on_camp_b_pressed() -> void:
	score_b+=1
	label_score_b.text=str(score_b)
