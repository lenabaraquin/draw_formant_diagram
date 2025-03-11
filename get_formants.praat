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

sound_name$ = "_"

sound_path$ = work_directory_path$ + sound_name$ + ".wav"
textgrid_path$ = work_directory_path$ + sound_name$ + ".TextGrid"
output_path$ = work_directory_path$ + "output.csv"

Read from file: sound_path$
selectObject: "Sound 'sound_name$'"
To Formant (burg): 0.01, 5.0, 5000, 0.025, 50.0

Read from file: textgrid_path$
selectObject: "TextGrid 'sound_name$'"
nb_intervals = Get number of intervals: 1
writeFileLine: "'output_path$'", "'sound_name$';phone;f1;f2;f3"

for interval from 1 to nb_intervals
  selectObject: "TextGrid 'sound_name$'"
  label$ = Get label of interval: 1, interval

  if label$ <> ""
    start = Get starting point: 1, interval
    end = Get end point: 1, interval
    midpoint = (start + end) / 2

    selectObject: "Formant 'sound_name$'"
    f1 = Get value at time: 1, midpoint, "Hertz", "Linear"
    f2 = Get value at time: 2, midpoint, "Hertz", "Linear"
    f3 = Get value at time: 3, midpoint, "Hertz", "Linear"

    resultline$ = "'sound_name$';'label$';'f1';'f2';'f3'"
    appendFileLine: "'output_path$'", "'resultline$'"
  endif
endfor
