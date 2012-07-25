  #! /bin/bash

# PATH_ARRAY=(`find . -type directory | sed "s/\(.*\)/'\1'/g"`)
# PATH_ARRAY_LEN=${#PATH_ARRAY[@]}

# for (( i=0; i<$PATH_ARRAY_LEN; i++ )); do
#   echo ${PATH_ARRAY[${i}]}
# done

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

declare -a PATH_ARRAY
let count=0

for folder in $( find . -type directory ); do
  PATH_ARRAY[$count]="'$folder'"
  ((count++))
done

PATH_ARRAY_LEN=${#PATH_ARRAY[@]}
echo $PATH_ARRAY_LEN
echo ${PATH_ARRAY[@]}

IFS=$SAVEIFS