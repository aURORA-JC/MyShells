#!/bin/bash 
list=""

read end target

for (( i=1; i<=${end}; i++ ));do
    list=${list}${i}
done

num=`echo ${list} | grep -o ${target} | wc -l`

echo ${num}
