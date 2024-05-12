#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "usage: $0 file1 file2 file3"
    exit 1
else
    echo "usage: $0 $1 $2 $3"
fi

echo "****************OSS1 - Project1**************"
echo "*            StudentID : 12211823           *"
echo "*            Name : Hyeonseo Lee            *"
echo "*********************************************"
 

 
ans=0
until [ $ans -eq 7 ]
do
    echo "[MENU]"
    echo "1. Get the data of Heung-Min Son’s Current Club, Appearance, Goals, Assists in players.csv"
    echo "2. Get the team data to enter a league position in teams.csv"
    echo "3. Get the Top-3 Attendance matches in mateches.csv"
    echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
    echo "5. Get the modified format of date_GMT in matches.csv"
    echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
    echo "7. Exit"
    read -p "Enter your CHOICE (1~7) : " choice
    
    case $choice in
    1) 
        read -p "Do you want to get the Heung-Min Son's data? (y/n) : " key
        if [ "$key" = "y" ]; then
            cat players.csv | awk -F',' '$1=="Heung-Min Son" {print "Team: ", $4, "Appearance: ", $6, "Goal: ", $7, "Assist: ", $8}'
        fi
        ;;
    2)
        read -p "What do you want to get the team data of league_position[1~20] : " key
        cat teams.csv | awk -F',' -v key="$key" '$2==key {print $6, " ", $1, " ", $2/($2+$3+$4)}'
        ;;
    3)
        read -p "Do you want to know Top-3 attendance data? (y/n): " key
        if [ "$key" = "y" ]; then
            cat matches.csv | awk -F',' '{print $3, " vs ", $4, " (", $1, ")\n", $2, " ", $7}' | sort -r -k2n | head -n 3
        fi
        ;;
    4)
        read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " key
        if [ "$key" = "y" ]; then
            IFS=,
            teams=()
            while read -r score name; do
                teams+=("$2, $1")
            done < teams.csv
            IFS=$'\n'
            sorted_teams=($(sort -r -t, -k2n <<<"${teams[*]}"))
            unset IFS
            rank=1
            for team in "${sorted_teams[@]}"; do
                IFS=,
                read -r score name <<< "$team"
                top_scorer=$(awk -F',' -v team_name="$name" '$4==team_name {print $1, $7}' players.csv | sort -r -k2n | head -n 1)
                printf "%d. %20s %s\n" "$rank" "$name" "$top_scorer"
                ((rank++))
                unset IFS
            done
        fi
        ;;
    5)
        read -p "Do you want to modify the format of date? (y/n): " key
        if [ "$key" = "y" ]; then
            cat $1 matches.csv | head -n 10 | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/\(am\|pm\)/\[\1\/\2\/\3 \4:\5\6]/g; s/ ([0-9]{2}):([0-9]{2})([ap]m)/ \1:\2\3/g'
        fi
        ;;
    6)
        list=($(cat teams.csv | awk -F','  '{print $1}'))
        select name in "${list[@]}"; do
            if [[ -n $name ]]; then
                echo -e "Enter your team number: ${name}\n\n"
                cat matches.csv | awk -F',' -v name=“$name” '$3==name{print $1, "\n", $3, " ", $5, " vs ", $6, " ", $4}' matches.csv
                break
            fi
        done
        ;;
    7)  echo "Bye"
        exit 0
        ;;
    esac
    echo
done
