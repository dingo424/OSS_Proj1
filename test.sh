#! /bin/bash
echo "---------------------------"
echo "User Name: 차인태"
echo "Student Number: 12201810"
echo "[ MENU ]"
option1="Get the data of the movie identified by a specific 'movie id' from 'u.item'"
option2="Get the data of action genre movies from 'u/tiem'"
option3="Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
option4="Delete the 'IMDb URL' from 'u.item'"
option5="Get the data about users from 'u.user'"
option6="Modify the format of 'release date' in 'u.item'"
option7="Get the data of movies rated by a specific 'user id' from 'u.data'"
option8="Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
option9="Exit
---------------------------"
PS3="Enter your choice [ 1-9 ]"
select var in "$option1" "$option2" "$option3" "$option4" "$option5" "$option6" "$option7" "$option8" "$option9"
do
	if [ "$var" = "$option1" ]
	then
		read -p "Please enter the 'movie id' (1~1682): " movnum

		awk -F "|" -v movnum="$movnum" '$1 == movnum {print}' "$1"

	elif [ "$var" = "$option2" ]
	then
		read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n):" yesno
		if [ "$yesno" = "y" ]
		then
			awk -F "|" 'actioncnt<10 && $7==1 { print $1, $2; actioncnt++ }' "$1"
		fi

	elif [ "$var" = "$option3" ]
	then
		read -p "Please enter the 'movie id' (1~1682): " movienum

		result=$(awk -v movienum="$movienum" '$2 == movienum { ratingsum += $3; people++ } END { if (people > 0) print ratingsum / people; else print 0 }' "$2")

		echo "Average rating of $movienum: $result"
	fi
done

