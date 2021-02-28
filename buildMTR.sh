#!/bin/bash 
declare -a list

read len part

for (( i=0; i<=${len}; i++ ));do
    list[${i}]=1
done

for (( i=0; i<${part}; i++ ));do
    read s e
    for (( j=${s}; j<=${e}; j++ ));do
        if [[ ${list[${j}]} -eq 1 ]];then
            list[${j}]=0;
        fi
    done
done

num=0
for (( i=0; i<=${len}; i++ ));do
    if [[ ${list[${i}]} -eq 1 ]];then
        let num+=1
    fi
done

echo ${num}
