curl -i https://api.github.com/users/devops090/repos -u devops090:d713effbefa571138b3aa7afb84a481822908b7a | sed -e 's/[{}]/''/g' | grep "name" | sed '/name/!d' | sed s/\"name\"://g | sed s/\"//g | sed s/\,//g | sed '/devops090/d'| xargs -n1 &>> ./repolist.txt
filename=repolist.txt
while read -r line; do
    name="$line"
    echo "Name read from file - $name"
    	git clone https://github.com/devops090/$name.git
    pwd
    cd $name
	#git checkout master
	#deleted merged branches on master branch
    tarBranch=$(git branch -r --merged | grep -v master | sed 's/origin\///')
	for branch in $tarBranch
	do
 	  echo $branch
 	  lastDate=$(git show -s --format=%ci origin/$branch)
          convertDate=$(echo $lastDate | cut -d' ' -f 1)
 	  Todate=$(date -d "$convertDate" +'%s')
          current=$(date +'%s')
 	  day=$(( ( $current - $Todate )/60/60/24 ))
          echo "last commit on $branch branch was $day days ago"
 	 	if [ "$day" -gt 90 ]; then
    	   	   echo git push origin :$branch
    		   echo "delete the old branch $branch"
 		fi
	done
done < "$filename"
