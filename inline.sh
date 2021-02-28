#!/bin/bash 
declare -a list

read total

for (( i=1; i<=${total}; i++ ));do
    read list[${i}]
done

sum=0

for (( i=1; i<=${total}; i++ ));do
    st=0
    ed=0
    for (( j=1; j<${i}; j++ ));do
        if [[ ${list[${j}]} -gt ${list[${i}]} ]];then
            let st+=1
        fi
    done

    for (( k=$[${i}+1]; k<=${total}; k++ ));do
        if [[ ${list[${k}]} -gt ${list[${i}]} ]];then
            let ed+=1
        fi
    done

    if [[ ${st} -eq ${ed} ]];then
        let sum+=1
    fi
done

echo ${sum}
