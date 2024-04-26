extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("text_animation")
 

func get_result(result):
	if result == "win":
		$Control/ResultLabel.text = "You've won" 
	elif result == "lose":
		$Control/ResultLabel.text = "GAME OVER" 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().reload_current_scene()
