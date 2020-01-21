subfunc () {
  #echo "$1 $2 -subfunction"
  dateformat=$(curl -u devops090:cd6d76c0e76a20c2148f667988ba280060156e96 -X GET https://api.github.com/repos/devops090/"$1"/commits/"$2" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1)
  convertDate=$(echo $dateformat | cut -d' ' -f 1)
  Todate=$(date -d "$convertDate" +'%s')
  current=$(date +'%s')
  day=$(( ( $current - $Todate )/60/60/24 ))
  echo "function3".$(date +'%s')
  if [ "$day" -gt 90 ]; then 
    &>> ./last_commit_history_of_braches.csv
  fi
  
}

execfunction () { 
  arr=("$@")
  while IFS=',' read -r f1 f2; do
        name_repo="$f1 $i"
        name_branch="$f2 $i"
        subfunc "$name_repo" "$name_branch" &
        echo "function2 $name_repo $name_branch".$(date +'%s')
  done < <(printf '%s\n' "${arr[@]}")

}

branch(){
      name="$1"
      branch=$(curl -u devops090:cd6d76c0e76a20c2148f667988ba280060156e96 -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1)
      execfunction "${branch[@]}" &
      echo "function1 $name".$(date +'%s')
}

func () {
  res=$(curl -i https://api.github.com/users/devops090/repos -u devops090:cd6d76c0e76a20c2148f667988ba280060156e96    | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1)
  while read -r line; do
      branch "$line" &
  done < <(printf '%s\n' "$res")
}

func
