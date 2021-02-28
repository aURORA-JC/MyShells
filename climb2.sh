#!/bin/bash 
declare -a list

read total

list[0]=0
list[1]=0
list[2]=1
list[3]=1

for (( i=4; i<=${total}; i++ ));do
    list[${i}]=`expr ${list[${i}-2]} + ${list[${i}-3]}`
done

echo ${list[${total}]}
