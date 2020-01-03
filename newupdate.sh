curl -i https://api.github.com/users/devops090/repos -u devops090:47bd0cddbac923af7c1ec9e2c0dfbec164aa0640| sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1 &>> ./repolist.csv
filename=repolist.csv
while read -r line; do
    name="$line"
    echo "Name read from file - $name"
        curl -u devops090:47bd0cddbac923af7c1ec9e2c0dfbec164aa0640 -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1 &>> ./branches_list.csv
  done < "$filename"
sed -e /^$/d branches_list.csv &>> ./repo_branch_list.csv
rm -rf branches_list.csv repolist.csv
#awk -F ',' '{print $2}' repo_branch_list.csv
repo_branch=repo_branch_list.csv
while read -r line; do
      name="$line"
     if [ "$name" -eq $@ ]; then
      echo "Name read from line - $name"
      variable1=(awk -F ',' '{print $1}' $name)
      name_repo="$variable1"
      echo "Name read from line - $name_repo"
      variable2=(awk -F ',' '{print $2}' $name)
      name_branch="$variable2"
      echo "Name read from line - $name_branch"
      fi
        curl -u devops090:47bd0cddbac923af7c1ec9e2c0dfbec164aa0640 -X GET https://api.github.com/repos/devops090/$name_repo/commits/$name_branch | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1 &>> ./lastcommit_date.csv
  done < "$repo_branch"
