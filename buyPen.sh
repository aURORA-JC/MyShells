#!/bin/bash 
value=26

read yuan jiao

cash=`expr ${yuan} \* 10 + ${jiao}`
num=`expr ${cash} / ${value}`

echo ${num}
