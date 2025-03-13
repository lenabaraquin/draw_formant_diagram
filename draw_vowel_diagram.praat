#DRAW_FORMANT_PLOT_FROM_TABLE.PRAAT
#AUTHOR: KRISTINE YU, Time-stamp: <2010-11-11 22:13:27 amoebe>
#LING 104, FALL 2010 JUN/YU, LAB 2: VOWEL FORMANTS
#=============================================================================================================
# Le script recherche les valeurs des formants (F1 et F2) correspondant au segment qui contient l'étiquette
# donnée à la procédure @draw_me_a_phone et crée un tableau de valeurs de formants.
# Il dessine ensuite le trapèze vocalique et l'enregistre dans le fichier "output.pdf"
# Ce fichier peut être créé en extrayant automatiquement les valeurs des formants à l'aide du script
# "get_formants.praat".
# Joaquim Llisterri, UAB, 14 de marzo de 2016
# Adapté par Anna Marczyk, UTJJ, 2023
# Adapté par Léna Baraquin, mars 2023
#=============================================================================================================

# Formulaire pour définir l'emplacement des fichiers
form: "Emplacement des fichiers"
  comment: "Sélectionnez le dossier dans lequel se trouve"
  comment: "le fichier contenant les formants."
  folder: "work_directory_path", ""
  comment: "Entrez le nom du fichier contenant les formants (sans l'extension)"
  sentence: "formant_file_name", "output"
  choice: "OS", 1
    option: "Windows"
    option: "MacOS"
    option: "Linux"
endform

# Définition de l'emplacement des fichiers
if "'OS$'" == "Windows"
  work_directory_path$ = work_directory_path$ + "\"
else
  work_directory_path$ = work_directory_path$ + "/"
endif
formant_file_name$ = "'formant_file_name$'"
formant_file_extension$ = ".csv"
formant_file_path$ = work_directory_path$ + formant_file_name$ + formant_file_extension$

# Valeurs minimales et maximales que peuvent prendre les premier et deuxième formants
beginPause: "Choix des plages de fréquences où se trouvent les formants"
  comment: "Entrez la valeur minimale puis maximale que peut prenre le premier formant :"
  integer: "f1_min", "100"
  integer: "f1_max", "1600"
  comment: "Entrez la valeur minimale puis maximale que peut prenre le second formant :"
  integer: "f2_min", "500"
  integer: "f2_max", "3500"
endPause: "Continue", 1

# Récupération des informations du fichier contenant les formants dans un objet Table
Read Table from semicolon-separated file: formant_file_path$
selectObject: "Table 'formant_file_name$'"

# Préparation du graphique
Erase all
Select outer viewport: 0, 4, 0, 5
Draw inner box
Marks left every: 1, 100, "yes", "yes", "yes"
Text left: "yes", "F1 (Hz)"
Marks top every: 1, 500, "yes", "yes", "yes"
Text top: "yes", "F2 (Hz)"

# Dessin des occurences des phones et du champ de dispersion pour chaque voyelle
vowel$ = "x"
while vowel$ <> ""
  beginPause: "Dessin des voyelles"
    comment: "Entrez la voyelle que vous souhaitez dessiner."
    comment: "Laissez vide si vous avez terminé."
    word: "vowel", ""
    choice: "color", 1
      option: "Black"
      option: "Blue"
      option: "Cyan"
      option: "Green"
      option: "Magenta"
      option: "Maroon"
      option: "Pink"
      option: "Red"
      option: "Yellow"
  endPause: "Next", 1
  if vowel$ <> ""
    @draw_me_a_phone: "'vowel$'", "'color$'", f1_min, f1_max, f2_min, f2_max
  endif
endwhile

# Définition de la taille de la fenêtre de dessin
Select outer viewport: 0, 5.5, 0, 5.7

# Enregistrement du graphique dans "output.pdf"
# Save as PDF file: work_directory_path$ + "output.pdf"

# Définition de la procédure utilisée pour dessiner les occurences et le champ de dispersion des phones
procedure draw_me_a_phone: phone$, color$, f1_min, f1_max, f2_min, f2_max
  selectObject: "Table output"
  Extract rows where column (text): "phone", "is equal to", "'phone$'"
  Colour: "'color$'"
  Scatter plot: "f2", f2_max, f2_min, "f1", f1_max, f1_min, "phone", 10, "no"
  Draw ellipse (standard deviation):  "f2", f2_max, f2_min, "f1", f1_max, f1_min, 2.0, "no"
endproc
