for f in *
do
  echo "$f"
  # if there is a 3rd arg
  dupeFileExtension=`echo "$f" | awk -F'.' '{print $3}'`
  actualFileExtension=`echo "$f" | awk -F'.' '{print $2}'`
  fileName=`echo "$f" | awk -F'.' '{print $1}'`
  if [ ! -z "$dupeFileExtension" ]; then
    echo "renaming file: $f"
    mv "$(printf '%s' ${f})" "$(printf '%s' "./${fileName}.${actualFileExtension}")"
  fi

done
