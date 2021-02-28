#!/bin/bash 
declare -a list

read total

list[1]=1
list[2]=1

for (( i=3; i<=${total}; i++ ));do
    list[${i}]=`expr ${list[${i}-1]} + ${list[${i}-2]}`
done

echo ${list[${total}]}
