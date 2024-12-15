#!/usr/bin/env bash
# HW2 Lior Tal
shopt -s globstar dotglob

DIR1="$1"
DIR2="$2"
OPTION="$3"

# Check if directories exist or not the same
if [[ ! -d "$DIR1" || ! -d "$DIR2" || "$DIR1" == "$DIR2" ]]; then
  echo "Both parameters must be different existing directories."
  exit 20
fi

# Check if directoris are symlink
if [[ -L "$DIR1" || -L "$DIR2" ]]; then
  echo "One of the directories is a symlink."
  exit 30
fi

# check only for the letter 'q'

if [[ "$OPTION" != "q" ]]; then
  echo "Third parameter is not 'q', Ignoring it."
  OPTION=""
fi


check_files_content_equal(){
    filename1="$1"
    filename2="$2"


    read -ra sum1<<<"$(md5sum "$filename1")"
    read -ra sum2<<<"$(md5sum "$filename2")"

    if [[ "${sum1[0]}" == "${sum2[0]}" ]]; then
      echo "$filename2 is a duplicate of $filename1"
      if [[ "$OPTION" == "q" ]]; then
         echo "Removing duplicated file $filename2"
         rm "$filename2"
        fi
    fi
}

shopt -s globstar dotglob # Recursively traverse directory in a for loop

for file1 in "$DIR1"/**; do
  if [[ -f "$file1" ]]; then
    for file2 in "$DIR2"/**; do
      if [[ -f "$file2" ]]; then
        check_files_content_equal "$file1" "$file2" "$OPTION"
      fi
    done
  fi
done
echo "Script HW2 completed."
exit 0
