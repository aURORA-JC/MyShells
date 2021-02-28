#!/bin/bash 
declare -a method

read total

method[1]=1
method[2]=2

for (( i=3; i<=${total}; i++ ));do
    method[${i}]=`expr ${method[${i}-1]} + ${method[${i}-2]}`
done

for (( i=1; i<=${total}; i++ ));do
    if [[ ${i} -ne 1 ]];then
        printf " "
    fi
    printf "%d" ${method[${i}]}
done
printf "\n"

