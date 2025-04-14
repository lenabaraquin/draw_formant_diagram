path$ = "\home\lena\Documents\patate.wav"

## primitives
#dot_index = rindex(path$, ".")
#separator_index = rindex(path$, "/")
#if separator_index == 0
#  separator_index = rindex(path$, "\")
#endif
#string_length = length(path$)
#diff_length = dot_index - separator_index
#
## chaines
#directory_path$ = left$(path$, separator_index)
#file_name$ = mid$(path$, separator_index + 1, diff_length - 1)
#extension$ = right$(path$, string_length - dot_index + 1)

@decompose_path: path$


# Affichage des résultats
writeInfoLine: "path : ", path$
writeInfoLine: "directory_path : ", decompose_path.directory_path$
writeInfoLine: "file_name : ", decompose_path.file_name$
writeInfoLine: "extension : ", decompose_path.extension$

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
