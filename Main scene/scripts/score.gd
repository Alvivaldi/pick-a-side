extends Node2D

@onready var ask : LineEdit = $Ask
@onready var info : Label = $Info

var nbj : int = 0
var liste_joueurs : Array[Joueur] = []
var tour_actuel : Tour = null

enum GameState {
	NB_JOUEURS,
	CHOIX_PREMIER_JOUEUR,
	CHOIX_DEUXIEME_JOUEUR,
	TOUR_EN_COURS
}
var etat : GameState = GameState.NB_JOUEURS


# --- CLASSES ---
class Joueur:
	var pseudo: String
	var score: int
	var peux_jouer: bool
	
	func _init(ps: String) -> void:
		pseudo = ps
		score = 0
		peux_jouer = true
		
	func _to_string() -> String:
		return "{ pseudo: %s, score: %d, peux_jouer: %s }" % [pseudo, score, peux_jouer]


class Tour:
	var dilemme: String
	var joueur1: Joueur
	var joueur2: Joueur
	
	func _init(j1: Joueur = null, j2: Joueur = null, d: String = ""):
		dilemme = d
		joueur1 = j1
		joueur2 = j2
		
	func _to_string() -> String:
		return "{ dilemme: %s, joueur1 : %s, joueur2 : %s }" % [dilemme, joueur1, joueur2]


# --- CYCLE DE VIE ---
func _ready() -> void:
	configurer_etat(GameState.NB_JOUEURS)


# --- GESTION DES ÉTATS (UI) ---
func configurer_etat(nouvel_etat: GameState) -> void:
	etat = nouvel_etat
	ask.text = ""
	
	match etat:
		GameState.NB_JOUEURS:
			ask.placeholder_text = "Entrez le nombre de joueurs :"
			info.text = "Bienvenue ! Indiquez le nombre de participants."
			
		GameState.CHOIX_PREMIER_JOUEUR:
			ask.placeholder_text = "Nom du premier joueur :"
			afficher_joueurs()
			
		GameState.CHOIX_DEUXIEME_JOUEUR:
			ask.placeholder_text = "Nom du deuxième joueur :"
			
		GameState.TOUR_EN_COURS:
			ask.placeholder_text = "Entrez le dilemme du tour :"
			info.text = "Tour créé :\n" + str(tour_actuel)


# --- ENTRÉE UTILISATEUR ---
func _on_asknbj_text_submitted(new_text: String) -> void:
	var saisie = new_text.strip_edges()
	if saisie.is_empty():
		return
		
	match etat:
		GameState.NB_JOUEURS:
			if saisie.is_valid_int() and int(saisie) > 1:
				nbj = int(saisie)
				initialiser_joueurs()
				configurer_etat(GameState.CHOIX_PREMIER_JOUEUR)
			else:
				info.text = "Veuillez entrer un nombre valide (> 1)."
				
		GameState.CHOIX_PREMIER_JOUEUR:
			var j = trouver_joueur_par_pseudo(saisie)
			if j != null:
				tour_actuel = Tour.new(j, null)
				configurer_etat(GameState.CHOIX_DEUXIEME_JOUEUR)
			else:
				info.text = "Joueur introuvable. Réessayez :\n" + obtenir_noms_joueurs()
				
		GameState.CHOIX_DEUXIEME_JOUEUR:
			var j = trouver_joueur_par_pseudo(saisie)
			if j != null and j != tour_actuel.joueur1:
				tour_actuel.joueur2 = j
				configurer_etat(GameState.TOUR_EN_COURS)
			else:
				info.text = "Joueur invalide ou identique au premier. Réessayez :"
				
		GameState.TOUR_EN_COURS:
			tour_actuel.dilemme = saisie
			print("Tour validé : ", tour_actuel)
			# Ici tu pourras enchaîner sur un nouveau tour ou une vérification


# --- LOGIQUE MÉTIER ---
func initialiser_joueurs() -> void:
	liste_joueurs.clear()
	for i in range(nbj):
		var nouveau_joueur = Joueur.new("Joueur " + str(i))
		liste_joueurs.append(nouveau_joueur)


func trouver_joueur_par_pseudo(pseudo: String) -> Joueur:
	for joueur in liste_joueurs:
		if joueur.pseudo.to_lower() == pseudo.to_lower():
			return joueur
	return null


func afficher_joueurs() -> void:
	var txt = "Liste des joueurs :\n"
	for joueur in liste_joueurs:
		txt += "- " + str(joueur) + "\n"
	info.text = txt


func obtenir_noms_joueurs() -> String:
	var noms = []
	for j in liste_joueurs:
		noms.append(j.pseudo)
	return ", ".join(noms)


func verif_tour() -> bool:
	var compteur : int = 0
	for joueur in liste_joueurs:
		if not joueur.peux_jouer:
			compteur += 1
	return compteur < 2