#!/bin/bash
sum=0

read a b

res=`expr ${a} % ${b}`

if [[ res -eq 0 ]];then
    echo "YES"
else
    echo "NO"
fi
