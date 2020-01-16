for ((i=1;i<=3;i++));do
	res=$(curl -i https://api.github.com/users/devops090/repos -u devops090:b5e81a8969f9b6c55d7cbd104ad6e27e32d41b04  | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1)
		while read -r line; do
			name="$line"
			echo "Name read from file - $name"
			for ((k=1;k<10;k++));do
				branch=$(curl -u devops090:b5e81a8969f9b6c55d7cbd104ad6e27e32d41b04 -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1)
				[[]-z "$branch"] && break
			fpfunction "$branch" &
		done
	done < <(printf '%s\n' "$res")
done

fpfunction(){
	while IFS=',' read -r f1 f2; do
			name_repo="$f1"
			name_branch="$f2"
		echo "Name read from line repo - $name_repo"
		echo "Name read from line branch - $name_branch"
		#sub=$(curl -u devops090:b5e81a8969f9b6c55d7cbd104ad6e27e32d41b04 -X GET https://api.github.com/repos/devops090/"$name_repo"/commits/"$name_branch" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1)
		dateformat=$(curl -u devops090:b5e81a8969f9b6c55d7cbd104ad6e27e32d41b04 -X GET https://api.github.com/repos/devops090/"$name_repo"/commits/"$name_branch" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1)
			convertDate=$(echo $dateformat | cut -d' ' -f 1)
		Todate=$(date -d "$convertDate" +'%s')
					current=$(date +'%s')
		day=$(( ( $current - $Todate )/60/60/24 ))
		if [ "$day" -gt 90 ]; then
			echo ""$name_repo","$name_branch","$dateformat","$day"-days ago" &>> ./last_commit_history_of_braches.csv
		fi
		
	done < <(printf '%s\n' "$1")
}
