#!/bin/bash

set -e

keyfile=${1}

if [ -z ${keyfile} ] ; then
    keyfile='./ssh_keys'
fi

if ! [ -r ${keyfile} ]; then
    echo "FATAL: could not read key file ${keyfile}!"
    exit 1
fi

tmpfile="/tmp/list-key-file-${RANDOM}${RANDOM}"

if [ -f ${tmpfile} ]; then 
    echo "FATAL: tmp file ${tmpfile} already exists!"
    exit 1
fi

>${tmpfile}

cat ${keyfile} | while read type key name ; do
    echo "${type} ${key} ${name}" > ${tmpfile}
    ssh-keygen -l -f ${tmpfile} | sed -e "s,${tmpfile},${name},"
done


rm ${tmpfile}

