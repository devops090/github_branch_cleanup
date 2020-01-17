execfunction () { 
  arr=("$@")
  echo "${arr[@]}"
}

func () {
  res=$(curl -i https://api.github.com/users/devops090/repos -u devops090:e952d0879410a1958c31fef0dcd24e443dd9be7e   | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1)
  while read -r line; do
      name="$line"
      echo "Name read from file - $name"
      branch=$(curl -u devops090:e952d0879410a1958c31fef0dcd24e443dd9be7e  -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1)
      execfunction "${branch[@]}" &
  done < <(printf '%s\n' "$res")
}

func
