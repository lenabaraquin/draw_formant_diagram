# This script is distributed under the GNU General Public License.
# Copyright 4.7.2003 Mietta Lennes
#=====================================================================================================
# Pour le fichier son défini et pour son TextGrid correspondant, les valeurs des formants vocalique 
# sont calculées au centre de chaque intervalle contenant une étiquette. Les résultats sont 
# enregistrés dans un fichier .csv avec les colonnes séparées par des point-virgules et les lignes 
# séparées par des retours à la ligne.
# Joaquim Llisterri, UAB, le 13 mars 2016
# Adaptation : Anna Marczyk, UTJJ, mars 2023
# Adaptation : Léna Baraquin, mars 2025
#=====================================================================================================

# Formulaire pour définir l'emplacement des fichiers
form: "Emplacement des fichiers"
  comment: "Sélectionnez le fichier son :"
  infile: "file_path", ""
  comment: "Attention, le fichier TextGrid doit se trouver dans le même dossier."
endform

# Execution de la procédure decompose_path
@decompose_path: file_path$

# Définition des différentes variables contenant les noms de fichiers
work_directory_path$ = decompose_path.directory_path$
sound_name$ = decompose_path.file_name$
sound_path$ = work_directory_path$ + sound_name$ + ".wav"
textgrid_path$ = work_directory_path$ + sound_name$ + ".TextGrid"
output_path$ = work_directory_path$ + "output.csv"

# Test d'ouverture des fichiers 
if fileReadable(sound_path$) == 0
  writeInfoLine: "Praat ne parvient pas à ouvrir le fichier ", sound_path$
elif fileReadable(textgrid_path$) == 0
  writeInfoLine: "Praat ne parvient pas à ouvrir le fichier ", textgrid_path$
  appendInfoLine: "Assurez vous que le fichier TextGrid ait le même nom que le fichier son."
  appendInfoLine: "Assurez vous que le fichier TextGrid et le fichier son soient dans le même dossier."
endif

# Formulaire pour définir les paramètres pour le calcul des formants
beginPause: "Paramètres pour le calcul des formants"
  comment: "Intervalle de temps qui sépare deux analyses (en s) :"
  real: "time_step", "0.01"
  comment: "Nombre de formants recherchés :"
  integer: "max_formants", "5"
  comment: "Seuil au dessous duquel les formants sont recherchés (en Hz):"
  comment: "5000 Hz pour une voix d'homme, 5500 Hz pour une voix de femme."
  real: "ceiling", "5500.0"
  comment: "Taille de la fenêtre d'analyse (en s):"
  real: "win_length", "0.025"
  comment: "Fréquence en dessous de laquelle un filtre passe-bas est appliqué (en Hz):"
  real: "pre_emphasis", "50.0"
endPause: "Continue", 1

# Ouverture du fichier son et calcul des formants
Read from file: sound_path$
selectObject: "Sound 'sound_name$'"
To Formant (burg): time_step, max_formants, ceiling, win_length, pre_emphasis

# Ouverture du fichier TextGrid et calcul du nombre de tier
Read from file: textgrid_path$
selectObject: "TextGrid 'sound_name$'"
nb_intervals = Get number of intervals: 1

# Ecriture de l'entête du fichier csv
writeFileLine: "'output_path$'", "'sound_name$';phone;f1;f2;f3"

# Extraction des valeurs des trois premiers formants du milieu de chaque segment annoté 
for interval from 1 to nb_intervals
  selectObject: "TextGrid 'sound_name$'"
  label$ = Get label of interval: 1, interval

  # Vérifie que le segment est annoté
  if label$ <> ""
    start = Get starting point: 1, interval
    end = Get end point: 1, interval
    midpoint = (start + end) / 2

    # Extrait les valeurs des trois premiers formants
    selectObject: "Formant 'sound_name$'"
    f1 = Get value at time: 1, midpoint, "Hertz", "Linear"
    f2 = Get value at time: 2, midpoint, "Hertz", "Linear"
    f3 = Get value at time: 3, midpoint, "Hertz", "Linear"

    resultline$ = "'sound_name$';'label$';'f1';'f2';'f3'"
    appendFileLine: "'output_path$'", "'resultline$'"
  endif
endfor

# Procédure pour extraire le répertoire et le nom du fichier
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
