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
  comment: "Sélectionnez le fichier contenant les formants :"
  infile: "formant_file", ""
  comment: "S'il a été généré avec le script get_formants.praat, il s'appelle surement 'output.csv'."
endform

# Définition du nom du fichier et de son chemin
@decompose_path: formant_file$
formant_file_path$ = formant_file$
formant_file_name$ = decompose_path.file_name$

# Test d'ouverture des fichiers 
if fileReadable(formant_file_path$) == 0
  writeInfoLine: "Praat ne parvient pas à ouvrir le fichier ", formant_file_path$
endif

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

# Dessin des légendes
Select outer viewport: 0, 4, 0, 5
Draw inner box
Marks left every: 1.0, 100.0, "yes", "yes", "yes"
Text left: "yes", "F1 (Hz)"
Marks top every: 1.0, 500.0, "yes", "yes", "yes"
Text top: "yes", "F2 (Hz)"

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

# Définition de la procédure pour extraire le répertoire et le nom du fichier
procedure decompose_path: .path$
  dot_index = rindex(.path$, ".")
  separator_index = rindex(.path$, "/")
  if separator_index == 0
    separator_index = rindex(.path$, "\")
  endif
  string_length = length(.path$)
  diff_length = dot_index - separator_index
  .directory_path$ = left$(.path$, separator_index)
  .file_name$ = mid$(.path$, separator_index + 1, diff_length - 1)
  .extension$ = right$(.path$, string_length - dot_index + 1)
endproc
