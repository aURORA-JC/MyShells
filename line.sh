#!/bin/bash 
declare -ai list

read total

read string

for (( i=1; i<=${total}; i++ ));do
    list[${i}]=`echo ${string} | cut -d' ' -f${i}`
done

read target
temp=${list[${total}]}

for (( i=${total}; i>${target}; i-- ));do
    j=`expr ${i} - 1`
    list[${i}]=${list[${j}]}
done
list[${target}]=${temp}

for (( i=1; i<=${total}; i++ ));do
    if [[ ${i} -ne 1 ]];then
        printf " "
    fi
    printf "%d" ${list[${i}]}
done

printf "\n"


