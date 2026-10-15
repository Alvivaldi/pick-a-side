extends Node

# On crée notre propre signal personnalisé. 
# On précise qu'il transportera deux informations : l'ID du joueur, et son choix.
signal un_joueur_a_vote(id_joueur, choix)

var port = 8080
# On utilise un vrai serveur TCP basique
var tcp_server := TCPServer.new()
# On va stocker les téléphones connectés dans ce dictionnaire
var sockets_connectes := {}

func _ready():
	var erreur = tcp_server.listen(port)
	if erreur == OK:
		print("✅ Serveur TCP ouvert sur le port ", port)
	else:
		print("❌ Erreur d'ouverture de port")

func _process(delta):
	# 1. On vérifie les nouvelles connexions entrantes
	if tcp_server.is_connection_available():
		var tcp_connexion = tcp_server.take_connection()
		accepter_nouvelle_connexion(tcp_connexion)
		
	# 2. On écoute tous les joueurs déjà connectés
	for id in sockets_connectes.keys():
		var socket = sockets_connectes[id]
		socket.poll() 
		
		var etat = socket.get_ready_state()
		
		if etat == WebSocketPeer.STATE_OPEN:
			# Boucle pour lire TOUS les messages en attente de ce joueur
			while socket.get_available_packet_count() > 0:
				var paquet_brut = socket.get_packet()
				var message_texte = paquet_brut.get_string_from_utf8()
				
				# --- NOUVEAUTÉ : LA LECTURE DU JSON ---
				
				# a) On crée un outil pour analyser le JSON
				var json = JSON.new()
				
				# b) On lui demande d'analyser notre phrase de texte
				var erreur_analyse = json.parse(message_texte)
				
				# c) On vérifie s'il a réussi (si le texte était bien formaté)
				if erreur_analyse == OK:
					# json.data contient maintenant notre Dictionnaire Godot !
					var donnees = json.data 
					
					# d) On s'assure que c'est bien un Dictionnaire
					if typeof(donnees) == TYPE_DICTIONARY:
						
						# e) On vérifie si la clé "action" existe dans ce dictionnaire
						if donnees.has("action"):
							
							# f) Si l'action est "vote", on agit !
							if donnees["action"] == "vote":
								# On extrait le choix en toute sécurité
								var son_choix = donnees["choix"]
								print("🎉 SUCCÈS ! Le joueur ", id, " a officiellement voté pour : ", son_choix)
								# Au lieu d'afficher dans la console, on hurle l'information dans le mégaphone !
								un_joueur_a_vote.emit(id, son_choix)
				else:
					print("⚠️ Avertissement : Message reçu non-JSON ou mal formaté.")

		elif etat == WebSocketPeer.STATE_CLOSED:
			print("👋 Le joueur ", id, " s'est déconnecté.")
			sockets_connectes.erase(id)

func accepter_nouvelle_connexion(tcp_connexion):
	# On crée un objet WebSocket pour discuter avec ce client
	var nouveau_socket = WebSocketPeer.new()
	# On force la poignée de main WebSocket sur cette connexion brute
	var erreur = nouveau_socket.accept_stream(tcp_connexion)
	
	if erreur == OK:
		# On génère un ID factice (basé sur l'heure) car on n'a plus le gestionnaire automatique
		var id_joueur = Time.get_ticks_msec()
		sockets_connectes[id_joueur] = nouveau_socket
		print("📱 Nouveau téléphone connecté ! ID attribué : ", id_joueur)





# Cette fonction prend un Dictionnaire et l'envoie à TOUS les téléphones connectés
func envoyer_a_tous(donnees_dict):
	# 1. On transforme notre dictionnaire en phrase de texte JSON
	var phrase_json = JSON.stringify(donnees_dict)
	
	# 2. Le réseau ne transporte pas de "phrases", mais des octets bruts. 
	# On convertit donc notre texte en un paquet d'octets.
	var paquet_octets = phrase_json.to_utf8_buffer()
	
	# 3. On boucle sur tous les téléphones connectés
	for id in sockets_connectes.keys():
		var socket = sockets_connectes[id]
		
		# On vérifie que la porte de ce joueur est toujours bien ouverte
		if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			# On envoie le colis !
			socket.put_packet(paquet_octets)
