execfunction () { 
  arr=("$@")
  # echo "${arr[@]}"
  while IFS=',' read -r f1 f2; do
      name_repo="$f1"
      name_branch="$f2"
      echo "Name read from line repo - $name_repo"
      echo "Name read from line branch - $name_branch"
      dateformat=$(curl -u devops090:f923fdc3841d3cd9b190946fda122168836548ff  -X GET https://api.github.com/repos/devops090/"$name_repo"/commits/"$name_branch" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1)
        convertDate=$(echo $dateformat | cut -d' ' -f 1)
        Todate=$(date -d "$convertDate" +'%s')
          current=$(date +'%s')
        day=$(( ( $current - $Todate )/60/60/24 ))
        if [ "$day" -gt 90 ]; then
          echo "$name_repo","$name_branch","$dateformat","$day-days ago" &>> ./last_commit_history_of_braches.csv
        fi
  done < <(printf '%s\n' "${arr[@]}")
}

func () {

  res=$(curl -i https://api.github.com/users/devops090/repos -u devops090:f923fdc3841d3cd9b190946fda122168836548ff   | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1)
  while read -r line; do
      name="$line"
      # echo "Name read from file - $name"
      branch=$(curl -u devops090:f923fdc3841d3cd9b190946fda122168836548ff  -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1)
      # echo "${branch[@]}"
      execfunction "${branch[@]}" &
  done < <(printf '%s\n' "$res")

}

func
