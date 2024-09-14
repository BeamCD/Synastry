extends Control

signal textbox_closed
#made new resource to easily create enemies and have their stats set.
#click and drag .tres file to "Enemy" in inspector on the battle scene
@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var current_card_health = 0 
#starts the textbox hidden
#starts the players health at the maximum of 40
func _ready():
	#set_health($PlayerContainer/ProgressBar, State.current_health, State.max_health) not made yet
	set_health($EnemyContainer/ProgressBar, State.current_health, State.max_health)
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	#current_card_health = card.health
	$Hand.hide()
	$Textbox.hide()
	$ActionPanel.hide()
	#plan to have this show once each turn and have a separate energy tracking system
	display_text("Beam plays a %s !" % enemy.name)
	var response = await self.textbox_closed
	$ActionPanel.show()
	#$hand.show() on this line in order to have hand appear after text state next action
	
#allows for the numbers to automatically adjust themselves 
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health,max_health]
	
#allows the player to click to make the text box disappear
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible):
		$Textbox.hide()
		emit_signal("textbox_closed")

#idk what this is
func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	display_text("%s hits you" % enemy.name)
	var response = await self.textbox_closed
	
	current_player_health = max(0, current_player_health - enemy.damage)
	#set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy) connect to player life total
	
	display_text("%s dealt %d combat damage" % [enemy.name, enemy.damage])
	
	

#function for the really ugly forfeit button which will quit the game
func _on_forfeit_pressed():
	display_text("You decided to give up...")
	var response = await self.textbox_closed
	get_tree().quit()


func _on_hand_pressed():
	$Hand.show()
	var response = await self.textbox_closed
	#change this to cardDamage later?
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy)
	
	$AnimationPlayer.play("EnemyDamaged")
	var animate = await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d combat damage" % State.damage)
	#needs WAYYYYYYYY more fleshing out T_T ik i had one job...
	#Ill give the cards more stats and textures to flesh them out and when the text "card triggers shows ill have it do said damage to the enemy
	if current_enemy_health == 0:
		display_text("%s was killed!" % enemy.name)
		get_tree().quit()
	enemy_turn()
