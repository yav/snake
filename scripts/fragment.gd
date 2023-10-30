extends Area2D

@export var lab = "H"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = lab
	


func _on_body_entered(_body):
	print("entered")
