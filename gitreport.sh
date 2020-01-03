rm -rf repolist.csv repo_branch_list.csv branches_list.csv
curl -i https://api.github.com/users/devops090/repos -u devops090:12ec1e8588c3e7518f1f2671905bb7d47f055d37 | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1 &>> ./repolist.csv
filename=repolist.csv
while read -r line; do
    name="$line"
      echo "Name read from file - $name"
        curl -u devops090:12ec1e8588c3e7518f1f2671905bb7d47f055d37 -X GET https://api.github.com/repos/devops090/$name/branches | sed -e 's/[{}]/''/g' | grep "name" | sed 's/name/'"$name"'/g' | sed s/\"//g | sed s/\,//g | sed 's/:/,/g' | sed 's/ //g' | grep -v master | sed 's/origin\///' | xargs -n1 &>> ./branches_list.csv
  done < "$filename"
sed -e /^$/d branches_list.csv &>> ./repo_branch_list.csv
rm -rf branches_list.csv repolist.csv
#awk -F ',' '{print $2}' repo_branch_list.csv
repo_branch=repo_branch_list.csv
while IFS=',' read -r f1 f2; do
  name_repo="$f1"
  name_branch="$f2"
     echo "Name read from line repo - $name_repo"
     echo "Name read from line branch - $name_branch"
        curl -u devops090:12ec1e8588c3e7518f1f2671905bb7d47f055d37 -X GET https://api.github.com/repos/devops090/"$name_repo"/commits/"$name_branch" | grep "date" | sed 's/date/'"$name_repo"','"$name_branch"'/g' | sed s/\"//g | sed 's/:/,/g' | sed 's/ //g' | head -n1 &>> ./lastcommit_date.csv
  done < "$repo_branch"
 
