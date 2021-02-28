#!/bin/bash
maxLen=0
maxFile=""
maxString=""
maxLine=0

function showResult() {
    printf "%s:%d:%s:%d\n" ${maxFile} ${maxLen} ${maxString} ${maxLine}
    # echo "${maxFile}:${maxLen}:${maxString}:${maxLine}"

}

function getLine() {
    # echo "get line num"
    # echo ${1}
    # echo ${2}
    maxLine=$(cat ${1} | grep -n ${2} | head -1 | cut -d":" -f1)
}

function fileChecker() {
    if [[ ! -f ${1} ]];then
        # echo "not match"
        return
    fi

    strings=$(cat ${1} | tr -s -c "a-zA-Z" "\n")
    # echo ${strings}

    for i in ${strings};do
        # echo "checking"
        len=$(echo -n ${i} | wc -c)
        if [[ ${len} -gt ${maxLen} ]];then
            maxLen=${len}
            maxString=${i}
            maxFile=${1}
            getLine ${1} ${maxString}
            # echo "AC"
        fi
    done
}

function dirChecker() {
    for i in `ls -A ${1}`;do
        # echo ${1}${i}
        # echo ${1}${i}
        if [[ -d ${1}/${i} ]];then
            # echo "a dir"
            dirChecker ${1}/${i}
        else
            # echo "a file"
            fileChecker ${1}/${i}
        fi
    done
}

if [[ $# -eq 0 ]];then
    # echo "0 paren"
    dirChecker "."
else
    # echo "more paren"
    for i in $@;do
        if [[ -d ${i} ]];then
            dirChecker ${i}
        else
            fileChecker ${i}
        fi
    done
fi

# echo ${maxLine}


showResult


