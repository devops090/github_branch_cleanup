subfunc () {
	dateformat=$(curl -u XXXXX:02372b4d3dbf6693e1e89405dba279871a45d7ea -X GET https://api.github.com/repos/XXDevops/"$name_repo"/commits/"$name_branch" | grep "date" | sed '/date/!d' | sed s/\"date\"://g | sed s/\"//g | sed 's/ //g' | head -n1)
		convertDate=$(echo $dateformat | cut -d' ' -f 1)
    Todate=$(date -d "$convertDate" +'%s')
    current=$(date +'%s')
		day=$(( ( $current - $Todate )/60/60/24 ))
	if [ "$day" -gt 90 ]; then
		echo "$name_repo","$name_branch","$dateformat","$day-days ago" &>> ./final_repo_branch_date_list.csv
	fi
}

execfunction () { 
  arr=("$@")
  #echo "${arr[@]}"
  while IFS=',' read -r f1 f2; do
      name_repo="$f1"
      name_branch="$f2"
      #echo "Name read from line repo - $name_repo"
      #echo "Name read from line branch - $name_branch"
		subfunc "$name_repo" "$name_branch" &
  done < <(printf '%s\n' "${arr[@]}")
}
subbranchfunc () {
		#branch_count="$1"
		#name="$2"
		#echo branch count - "$branch_count"
		 #for ((k=1;k<700;k++)); do
		    echo "curl -u XXXXX:02372b4d3dbf6693e1e89405dba279871a45d7ea -X GET https://api.github.com/repos/XXDevops/"$name"/branches?page="$k" | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1"
	 	    [[ -z "$repo_branch_list" ]] && break     # echo "${repo_branch_list[@]}
		    execfunction "${repo_branch_list[@]}" &
		#done
}
branchfunction () { 
	name="$1"
  #echo name - "$name"
   # for ((k=1;k<700;k++)); do
	subbranchfunc "$name" &
  #  done
}
func () {
 for ((i=1;i<=3;i++)); do
	repolist="$(curl -i https://api.github.com/orgs/XXDevops/repos?page=$i -u XXXX:02372b4d3dbf6693e1e89405dba279871a45d7ea | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/full_name/d' | sed '/labels_url/d' | xargs -n1)"
     while read -r line; do
	  for ((k=1;k<700;k++)); do
	    branchfunction "$line" &
      # echo "Name read from file - $name"
      done
   done < <(printf '%s\n' "$repolist")
done
}
func
