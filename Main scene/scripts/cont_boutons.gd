extends Node2D
var dilemme_choisi :int
signal choix_fait

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dilemme_1_pressed() -> void:
	dilemme_choisi =1
	emit_signal("choix_fait")


func _on_dilemme_2_pressed() -> void:
	dilemme_choisi =2
	emit_signal("choix_fait")


func _on_dilemme_3_pressed() -> void:
	dilemme_choisi =3
	emit_signal("choix_fait")


func _on_dilemme_4_pressed() -> void:
	dilemme_choisi =4
	emit_signal("choix_fait")


func _on_dilemme_5_pressed() -> void:
	dilemme_choisi =5
	emit_signal("choix_fait")
