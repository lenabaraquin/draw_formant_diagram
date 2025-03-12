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
  folder: "work_directory_path", ""
  sentence: "sound_name", ""
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
sound_name$ = sound_name$
sound_path$ = work_directory_path$ + sound_name$ + ".wav"
textgrid_path$ = work_directory_path$ + sound_name$ + ".TextGrid"
output_path$ = work_directory_path$ + "output.csv"

# Ouverture du fichier son et calcul des formants
Read from file: sound_path$
selectObject: "Sound 'sound_name$'"
#To Formant (burg): time step, max number of formants, formant ceiling, window length, pre-emphasis from
To Formant (burg): 0.01, 5.0, 5000, 0.025, 50.0

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
