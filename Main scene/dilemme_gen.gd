extends Node


var dict_dilemme=[
	{
		"dilemme":"Tu préfère",
		"choixA":"gateau caca",
		"choixB":"caca gateau"
	},
	{
		"dilemme":"Dilemme 2",
		"choixA":"choix A",
		"choixB":"choix B"
	},
	{
		"dilemme":"Dilemme 3",
		"choixA":"choix A",
		"choixB":"choix B"
	},
	{
		"dilemme":"Dilemme 4",
		"choixA":"choix A",
		"choixB":"choix B"
	},
	{
		"dilemme":"Dilemme 5",
		"choixA":"choix A",
		"choixB":"choix B"
	},
	{
		"dilemme":"Dilemme 6",
		"choixA":"choix A",
		"choixB":"choix B"
	},
	{
		"dilemme":"Dilemme 7",
		"choixA":"choix A",
		"choixB":"choix B"
	}
]

func _ready():
	# We can't use dot syntax here as `my_color` is a variable.
	get_random_dilemme_list(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#met en forme dictionnaire
func mise_en_forme(di) :
	var text=""
	for el in di:
		# print(el)
		for cle in el:
			text+=el[cle]+" ,"
			# print(el[cle])
		text+="\n"
	return text
		
#renvoi tableau avec en premier, la mise en forme des n dilemmes, puis le dict des n dilemmes
func get_random_dilemme_list(nb: int):
	var dilemme_list=[]
	var used_dilemme=[]

	for i in range(nb):
		while true:
			var dilemme =randi_range(0,dict_dilemme.size()-1)
			if ( dict_dilemme[dilemme] not in used_dilemme):
				dilemme_list.append(dict_dilemme[dilemme])
				used_dilemme.append(dilemme_list[i])
				break
	print(dilemme_list)
	
	return [mise_en_forme(dilemme_list),dilemme_list]
	



	
