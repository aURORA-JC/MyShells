#!/bin/bash
sum=0

read end target

for (( i=1; i<=${end}; i++ ));do
    temp=${i}
    while [[ ${temp} -ne 0 ]];do
        res=`expr ${temp} % 10`
        temp=`expr ${temp} / 10`
        if [[ ${res} -eq ${target} ]];then
            let sum+=1
        fi
    done
done

echo ${sum}
