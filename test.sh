subfunc () {
  dateformat=$(curl -u devops090:a101f691b4b02610a618ea4720bfba80cc187dd2  -X GET https://api.github.com/repos/devops090/"$1"/commits/"$2" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1)
  convertDate=$(echo $dateformat | cut -d' ' -f 1)
  Todate=$(date -d "$convertDate" +'%s')
  current=$(date +'%s')
  day=$(( ( $current - $Todate )/60/60/24 ))
  if [ "$day" -gt 90 ]; then
    echo "$name_repo","$name_branch","$dateformat","$day-days ago" &>> ./last_commit_history_of_braches.csv
  fi
}
execfunction () { 
  arr=("$@")
  while IFS=',' read -r f1 f2; do
        name_repo="$f1"
        name_branch="$f2"
        echo "Name read from line repo - $name_repo"
        echo "Name read from line branch - $name_branch"
        subfunc "$name_repo" "$name_branch" &
  done < <(printf '%s\n' "${arr[@]}")
}

func () {

  res=$(curl -i https://api.github.com/users/devops090/repos -u devops090:a101f691b4b02610a618ea4720bfba80cc187dd2   | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1)
  while read -r line; do
      name="$line"
      branch=$(curl -u devops090:a101f691b4b02610a618ea4720bfba80cc187dd2  -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1)
      execfunction "${branch[@]}" &
  done < <(printf '%s\n' "$res")

}

func
