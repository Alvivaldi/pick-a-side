extends Node2D
@onready var ask :LineEdit=$Ask
@onready var info:Label=$Info
var nbj:int =0
var score_joueur : Dictionary={}
var liste_joueurs:Array=[]


enum EtatQuestion {
    NB_JOUEURS,
    CHOIX_PREMIER_JOUEUR
}
var etat=EtatQuestion.NB_JOUEURS

class Joueur:
	var pseudo:String
	var score: int
	var peux_jouer:bool
	func _init(ps) -> void:
		pseudo=ps
		score=0
		peux_jouer=true
	func _to_string() -> String:
		
		return "{ pseudo: %s, score: %d, peux_jouer: %s }" % [pseudo, score, peux_jouer]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func print_player(liste_joueurs)->void:
	info.text=""
	for joueur in liste_joueurs:
		print(joueur)
		info.text+=str(joueur)+"\n"


func init_joueurs(nbj):
	for i in range(nbj):
		var nouveau_joueur=Joueur.new("Joueur " + str(i))
		liste_joueurs.append(nouveau_joueur)
	print_player(liste_joueurs)
	verif_tour()
	


func _on_asknbj_text_submitted(new_text: String) -> void:
	match etat:
		EtatQuestion.NB_JOUEURS:
			nbj=int(new_text)
			init_joueurs((nbj))
		EtatQuestion.CHOIX_PREMIER_JOUEUR:
			pass


#retourne true si fin du tour
func verif_tour():
	var compteur:int=0
	for joueur in liste_joueurs:
		if not joueur.peux_jouer:
			compteur+=1
	print(compteur)
	if compteur <2:
		return true
	else :
		return false


func choix_joueurs():
	ask.placeholder_text="Entrer numéro du premier joueur"


