work_directory_path$ = "_"
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
