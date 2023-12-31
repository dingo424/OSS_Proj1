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
	echo ""
	if [ "$var" = "$option1" ]
	then
		read -p "Please enter the 'movie id' (1~1682): " movnum
		echo ""
		awk -F "|" -v movnum="$movnum" '$1 == movnum {print}' "$1"

	elif [ "$var" = "$option2" ]
	then
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " yn
		if [ "$yn" = "y" ]
		then
			echo ""
			awk -F "|" 'actioncnt<10 && $7==1 { print $1, $2; actioncnt++ }' "$1"
		fi

	elif [ "$var" = "$option3" ]
	then
		read -p "Please enter the 'movie id' (1~1682): " movnum
		echo ""
		result=$(awk -v movnum="$movnum" '$2 == movnum { ratingsum += $3; people++ } END { if (people > 0) print ratingsum / people; else print 0 }' "$2")

		echo "Average rating of $movnum: $result"

	elif [ "$var" = "$option4" ]
	then
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " yn
		if [ "$yn" = "y" ]
		then
			echo ""
			sed -E -n '1,10 { s/([^\|]*\|[^\|]*\|[^\|]*\|[^\|]*\|)([^\|]*)(\|[^\|]*\|.*)/\1\3/; p }' "$1"
		fi
	elif [ "$var" = "$option5" ]
	then
		read -p "Do you want to get the data about users from 'u.user'?(y/n): " yn
		if [ "$yn" = "y" ]
		then
			echo ""
			for i in $(seq 1 10)
			do
				gender=$(sed -n "${i}p" "$3" | sed -E 's/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|(.*)/\3/')
				case "$gender" in
					"M")
					gender="male"
					;;
					"F")
					gender="female"
					;;
				esac
				part1=$(sed -n "${i}p" "$3" | sed -E 's/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|(.*)/user \1 is \2 years old/')
				part2=$(sed -n "${i}p" "$3" | sed -E 's/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|(.*)/\4/')
				echo "${part1} ${gender} ${part2}"
			done
			
		fi
	elif [ "$var" = "$option6" ]
	then
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n): " yn
		if [ "$yn" = "y" ]
		then
			echo ""
			for i in $(seq 1673 1682)
			do
    			month=$(sed -n "${i}p" "$1" | sed -E 's/[^|]*\|[^|]*\|([^-|]*)-([^-|]*)-([^\|]*).*/\2/')
				case "$month" in
					"Jan")
					month="01"
					;;
					"Feb")
					month="02"
					;;
					"Mar")
					month="03"
					;;
					"Apr")
					month="04"
					;;
					"May")
					month="05"
					;;
					"Jun")
					month="06"
					;;
					"Jul")
					month="07"
					;;
					"Aug")
					month="08"
					;;
					"Sep")
					month="09"
					;;
					"Oct")
					month="10"
					;;
					"Nov")
					month="11"
					;;
					"Dec")
					month="12"
					;;
				esac
				part1=$(sed -n "${i}p" "$1" | sed -E 's/([^|]*\|[^|]*\|)([^-\|]*)-([^-\|]*)-([^\|]*)(.*)/\1\4/')
				part2=$(sed -n "${i}p" "$1" | sed -E 's/([^|]*\|[^|]*\|)([^-\|]*)-([^-\|]*)-([^\|]*)(.*)/\2\5/')
				echo "${part1}${month}${part2}"
			done
		fi
	elif [ "$var" = "$option7" ]
	then
		read -p "Please enter the 'user id'(1~943): " uid
		echo ""
		movies=$(awk -v uid="$uid" '$1 == uid {print $2}' "$2" | sort -n)
		echo "$movies" | tr '\n' '|'
		echo ""
		echo ""
		n=0
		for i in $movies
		do
			awk -F "|" -v mov="$i" '$1 == mov {print $1"|"$2}' "$1"
			((++n))
			if [ $n -eq 10 ]
			then
				break
			fi
		done
	elif [ "$var" = "$option8" ]
	then
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)" yn
		if [ "$yn" = "y" ]
		then
			echo ""
			for i in $(seq 1 1672)
			do
				people=0;
				rating=0;
				raters=$(awk -v mov="$i" '$2 == mov {print $1}' "$2")
				for j in $raters
				do
					age=$(sed -n "${j}p" "$3" | sed -E 's/([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|.*/\2/')
					occupation=$(sed -n "${j}p" "$3" | sed -E 's/([^\|]*)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|.*/\4/')
					if [ $((age)) -ge 20 -a $((age)) -le 29 -a "$occupation" = "programmer" ]
					then
						rate=$(awk -v mov="$i" -v uid="$j" '$2 == mov && $1 == uid {print $3}' "$2")
						rating=$((rating + rate))
						((people++))
					fi
				done
				if [ $((people)) -gt 0 ]
				then
					echo $i $rating $people | awk '{printf "%d %.5f\n", $1, $2 / $3}'
				fi
			done
		fi
	elif [ "$var" = "$option9" ]
	then
		echo "Bye!"
		break
	fi
	echo ""
done

