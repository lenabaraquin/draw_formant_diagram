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

work_directory_path$ = "_"
formant_file_name$ = "_"
formant_file_extension$ = "_"
formant_file_path$ = work_directory_path$ + formant_file_name$ + formant_file_extension$

f1_min = 100
f1_max = 1600
f2_min = 500
f2_max = 3500

Read Table from semicolon-separated file: formant_file_path$
selectObject: "Table formant_file_name$"

Select outer viewport: 0, 4, 0, 5
Draw inner box
Marks left every: 1, 100, "yes", "yes", "yes"
Text left: "yes", "F1 (Hz)"
Marks top every: 1, 500, "yes", "yes", "yes"
Text top: "yes", "F2 (Hz)"

@draw_me_a_phone: "a", "Red", f1_min, f1_max, f2_min, f2_max
@draw_me_a_phone: "e", "Blue", f1_min, f1_max, f2_min, f2_max
@draw_me_a_phone: "o", "Green", f1_min, f1_max, f2_min, f2_max

Select outer viewport: 0, 5.5, 0, 5.7

Save as PDF file: work_directory_path$ + "output.pdf"

procedure draw_me_a_phone: phone$, color$, f1_min, f1_max, f2_min, f2_max
  selectObject: "Table output"
  Extract rows where column (text): "phone", "is equal to", "'phone$'"
  Colour: "'color$'"
  Scatter plot: "f2", f2_max, f2_min, "f1", f1_max, f1_min, "phone", 10, "no"
  Draw ellipse (standard deviation):  "f2", f2_max, f2_min, "f1", f1_max, f1_min, 2.0, "no"
endproc
