extends Node


var dict_dilemme=[
	{
		"dilemme":"Dilemme 1",
		"choixA":"choix A",
		"choixB":"choix B"
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

func get_random_dilemme_list(nb: int):
	var dilemme_list=[]
	var used_dilemme=[]

	for i in range(nb):
		var dilemme =randi_range(0,dict_dilemme.size())
		
		print(dilemme)



	