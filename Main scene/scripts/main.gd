extends Control

enum GameState { WAITING_PLAYERS, DILEMMA_REVEAL, DEBATE, VOTING, RESULTS }
var current_state: GameState = GameState.WAITING_PLAYERS
@onready var label_principal :Label = $Liste_D
@onready var liste_dilemmes : Array= $DilemmeGen.dict_dilemme
@onready var dilemme_gen : Node=$DilemmeGen
@onready var cont_bouton: Node2D=$ContBoutons
@onready var gestion_vote: Node2D=$Vote
func _ready():
	# Le symbole '$' permet d'accéder directement à un nœud enfant. 
	# C'est comme un document.getElementById() en JS.
	$Label.text = "Phase : Attente des joueurs..."
	if (cont_bouton.visible==true ):
		hide_dilemme()
	
#Cache ou montre les 5 boutons de dilemmes
func hide_dilemme()->void:
	cont_bouton.hide()
	
func show_dilemme()->void:
	cont_bouton.show()


#change états de jeu
func change_state(new_state: GameState)->void:
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
			gestion_vote.start_vote()
		GameState.RESULTS:
			$Label.text = "Le gagnant est..."
			nom_de_la_phase = "RESULTATS"
			start_result()


	# NOUVEAU : On prépare le colis pour les téléphones
	var colis = {
		"phase_actuelle": nom_de_la_phase,
		"afficher_bouton_vote": afficher_bouton
	}
	
	# On donne l'ordre à notre serveur d'envoyer ça à tout le monde
	$NetworkServer.envoyer_a_tous(colis)

#affiche résultat en fonction nb votes
func start_result():
	var texte:String ="La manche est remporté par le camp "
	if gestion_vote.score_a>gestion_vote.score_b:
		print("A a gagné")
		texte+="A"
	elif gestion_vote.score_a<gestion_vote.score_b :
		texte+="B"
	else:
		texte="Egalité"
	label_principal.text=texte

var dilemmes

#demande liste dilemmes, les distritbue dans les boutons
func Display_Dilemme():
	show_dilemme()
	pass
	var reponse=dilemme_gen.get_random_dilemme_list(5)
	var texte=reponse[0]
	dilemmes=reponse[1]
	var i=0
	for el in dilemmes:
		for cle in el:
			cont_bouton.get_child(i).text=el[cle]+" ,"
		i+=1
	# label_principal.text=texte



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

#affiche dilemme choisi/ un dictionnaire simple
func mise_en_forme_dic(dic)->String:
	var text=""
	for cle in dic:
		text+=dic[cle]+" ,"
	return text
		

#si on appuis sur bouton dilemmes, selesctionne le dilemme et l'affiche en haut
func _on_cont_boutons_choix_fait() -> void:
	var dilemme_choisi=dilemmes[cont_bouton.dilemme_choisi-1]
	print(dilemme_choisi)
	hide_dilemme()
	# label_principal.text=dilemme_gen.mise_en_forme()
	var texte=mise_en_forme_dic(dilemme_choisi)
	label_principal.text=texte
	$Button.pressed.emit()
	print(texte)


func _on_shuffle_pressed() -> void:
	Display_Dilemme()
