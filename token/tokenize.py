# Programme permettant la tokenization des mots de l'extrait du Manuscrit du Roi. Cette tokenization doit permettre par la suite à lemmatiser les mots obtenus pour arriver au tableau de lemmatisation.
# Auteur : Pierre Tuloup
# Date : 26/04/2021

import re #import de la bibliothèque pour les expressions régulières

text = re.sub('<[^<]+>', "", open("Français_844_tr_graphematique.xml").read()) #je supprime tout ce qui se trouve contenu dans une balise, qui ne correspond pas à du texte
rgx = re.compile("([\w][\w']*\w)") # regex pour découper une liste de mots encadrée par des espaces et ne prendre que les mots
resultat = rgx.findall(text) # affichage de la liste

for word in resultat : # pour chaque mot dans la liste
    word = "<w>" + word + "</w>" # mise en place du format d'encadrement du mot par des balises w


resultat = ['<w>{0}</w>'.format(element) for element in resultat] # afficher chaque mot de la liste encadré par les balises w

resultat = '\n'.join(resultat) # mettre chaque mot balisé sur une ligne
print(resultat) # afficher le résultat

with open("result.xml", "w") as f: # transférer le résultat obtenu dans un fichier nommé result.xml
    f.write(resultat)
