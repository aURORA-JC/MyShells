#!/bin/bash

declare -a prime
sum=0

for (( i=0; i<=10000;i++ ));do
    prime[${i}]=0;
done

for (( i=2; i<=10000; i++ ));do
    if [[ ${prime[$i]} -eq 0 ]];then
        prime[0]=$[ ${prime[0]} + 1 ]
        prime[${prime[0]}]=$i
        sum=$[ ${sum} + $i ]
    fi

    for (( j=1; j<=${prime[0]}; j++ ));do
        if [[ $[ ${i} * ${prime[$j]} ] -gt 10000 ]];then
            break
        fi
        prime[ $[ ${i} * ${prime[$j]} ] ]=1
        if [[ $[ ${i} % ${prime[$j]} ] -eq 0 ]];then
            break
        fi
    done
done

echo ${sum}
