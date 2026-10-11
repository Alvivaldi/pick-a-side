extends Control

enum GameState { WAITING_PLAYERS, DILEMMA_REVEAL, DEBATE, VOTING, RESULTS }
var current_state: GameState = GameState.WAITING_PLAYERS
@onready var LabelD = $Liste_D
@onready var Dilemmes = $DilemmeGen.dict_dilemme
func _ready():
	# Le symbole '$' permet d'accéder directement à un nœud enfant. 
	# C'est comme un document.getElementById() en JS.
	$Label.text = "Phase : Attente des joueurs..."

func change_state(new_state: GameState):
	current_state = new_state
	
	# Par défaut, on va cacher le bouton de la manette
	var afficher_bouton = false
	var nom_de_la_phase = ""
	
	match current_state:
		GameState.WAITING_PLAYERS:
			$Label.text = "Attente des joueurs..."
			nom_de_la_phase = "ATTENTE"
			
		GameState.DILEMMA_REVEAL:
			$Label.text = "Dilemme : Choisisser le dilemme ?"
			Display_Dilemme()
			
			nom_de_la_phase = "DILEMME"
			
		GameState.DEBATE:
			$Label.text = "Débat en cours ! Argumentez !"
			nom_de_la_phase = "DEBAT"
			
		GameState.VOTING:
			$Label.text = "C'est l'heure de voter !"
			nom_de_la_phase = "VOTE"
			afficher_bouton = true # C'est la SEULE phase où on a besoin du bouton !
			
		GameState.RESULTS:
			$Label.text = "Le gagnant est..."
			nom_de_la_phase = "RESULTATS"

	# NOUVEAU : On prépare le colis pour les téléphones
	var colis = {
		"phase_actuelle": nom_de_la_phase,
		"afficher_bouton_vote": afficher_bouton
	}
	
	# On donne l'ordre à notre serveur d'envoyer ça à tout le monde
	$NetworkServer.envoyer_a_tous(colis)

	
func Display_Dilemme():
	pass
	# var liste=[]
	# for i in range(3) :
	# 	liste[i]=randi_range(0,(Dilemmes))
	# print(liste)



# Cette fonction est appelée automatiquement quand on clique sur le bouton
func _on_button_pressed():
	# Petite logique pour passer d'une phase à l'autre manuellement pour tester
	if current_state == GameState.WAITING_PLAYERS:
		change_state(GameState.DILEMMA_REVEAL)
	elif current_state == GameState.DILEMMA_REVEAL:
		change_state(GameState.DEBATE)
	elif current_state == GameState.DEBATE:
		change_state(GameState.VOTING)
	elif current_state == GameState.VOTING:
		change_state(GameState.RESULTS)
	elif current_state == GameState.RESULTS:
		change_state(GameState.WAITING_PLAYERS) # On boucle au début

func _on_network_server_un_joueur_a_vote(id_joueur: Variant, choix: Variant) -> void:
	# On s'assure qu'on est bien dans la phase de vote, sinon on ignore !
	if current_state == GameState.VOTING:
		
		# On modifie le texte à l'écran pour prouver que ça marche
		$Label.text = "Le joueur " + str(id_joueur) + " a voté pour : " + choix
		
	else:
		print("Vote ignoré : ce n'est pas le moment de voter !")
